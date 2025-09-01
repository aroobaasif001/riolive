import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../socket/incoming_calls.dart';
import '../utile/app_url.dart';

class CallController extends GetxController {
  /// Keep a fallback in case server doesn't return appId
  static const String fallbackAppId = "6569a35538f247de9b0e7a4b7de82604";

  var isLoading = false.obs;
  RtcEngine? engine;
  var remoteUid = RxnInt();
  var isMuted = false.obs;

  String? _channel; // current channel
  String? _currentToken; // current Agora token
  String? _serverAppId; // latest appId from server
  int _uid = 0; // uid used to join (must match server)
  bool _tearingDown = false; // cleanup guard
  RtcEngineEventHandler? _handler; // stored for unregister

  // Add these for better state tracking
  String? _currentCallId;
  bool _isLiveHost = false;

  int _deriveUid() {
    final parsed = int.tryParse(AppUrl.riolive_id.toString());
    return parsed ?? 0;
  }

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
    bool isHost = false,
    bool isAudience = false,
    String? callId,
  }) async {
    try {
      final mic = await Permission.microphone.request();
      final cam = await Permission.camera.request();
      if (!mic.isGranted || !cam.isGranted) {
        Get.snackbar("Permission Denied", "Camera & Microphone are required");
        return;
      }

      if (engine != null) {
        await leaveChannel();
      }

      _channel = channelName;
      _currentToken = agoraToken;
      _uid = _deriveUid();
      _currentCallId = callId;

      engine = createAgoraRtcEngine();
      final appIdToUse = _serverAppId ?? fallbackAppId;
      await engine!.initialize(RtcEngineContext(appId: appIdToUse));

      // Default audio route -> speaker
      await engine!.setDefaultAudioRouteToSpeakerphone(true);

      // Stable encoder profile (540p @ 15fps)
      await engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 960, height: 540),
          frameRate: 15,
        ),
      );

      // Enable video; turn local capture on/off by role
      await engine!.enableVideo();
      await engine!.enableLocalVideo(!isAudience);

      // Build ONE handler instance; store for unregister
      _handler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          debugPrint(
            "✅ Joined ${connection.channelId} uid=${connection.localUid}",
          );
          if (!isAudience) {
            await engine?.startPreview();
          }
        },
        onUserJoined: (RtcConnection _, int uid, int __) {
          debugPrint("👤 User joined: $uid");
          remoteUid.value = uid;
        },
        onUserOffline:
            (RtcConnection _, int uid, UserOfflineReasonType reason) {
              debugPrint("👤 User left: $uid, reason: $reason");
              remoteUid.value = null;
            },
        onLeaveChannel: (RtcConnection _, RtcStats __) {
          debugPrint("📤 Left channel");
          remoteUid.value = null;
        },

        // Token refresh handlers
        onRequestToken: (RtcConnection connection) {
          debugPrint("🔑 Token requested");
          _handleTokenRefreshRequest(isAudience);
        },

        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint("🔑 Token will expire");
          _handleTokenRefreshRequest(isAudience);
        },

        // Handle errors including token issues
        onError: (ErrorCodeType err, String msg) {
          debugPrint("❌ Agora error: $err - $msg");
          _handleAgoraError(err, isAudience);
        },

        // Connection state changes
        onConnectionStateChanged:
            (
              RtcConnection connection,
              ConnectionStateType state,
              ConnectionChangedReasonType reason,
            ) {
              debugPrint("🔗 Connection state: $state, reason: $reason");
            },
      );
      engine!.registerEventHandler(_handler!);

      // Join with proper role configuration
      await engine!.joinChannel(
        token: _currentToken!,
        channelId: _channel!,
        uid: _uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: isAudience
              ? ClientRoleType.clientRoleAudience
              : ClientRoleType.clientRoleBroadcaster,
          // Enable both audio and video for 1-to-1 calls
          publishMicrophoneTrack: !isAudience,
          publishCameraTrack: !isAudience,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      debugPrint("🚀 Agora initialized successfully");
    } catch (e) {
      debugPrint("Agora init error: $e");
      Get.snackbar("Error", "Agora init failed: $e");
    }
  }

  // Enhanced token refresh with better error handling
  void _handleTokenRefreshRequest(bool isAudience) async {
    if (_channel == null || _tearingDown) return;

    debugPrint("🔄 Refreshing token for channel: $_channel");
    try {
      final newToken = await fetchAgoraToken(
        token: AppUrl.token,
        channelName: _channel!,
        uid: _uid,
        role: isAudience ? 'subscriber' : 'publisher',
      );

      if (newToken?.isNotEmpty == true && engine != null) {
        _currentToken = newToken;
        await engine?.renewToken(newToken!);
        debugPrint("✅ Token renewed successfully");
      } else {
        debugPrint("❌ Failed to get new token");
        Get.snackbar("Warning", "Token refresh failed");
      }
    } catch (e) {
      debugPrint("Token refresh error: $e");
    }
  }

  // Enhanced error handling
  void _handleAgoraError(ErrorCodeType err, bool isAudience) async {
    debugPrint("🚨 Handling Agora error: $err");

    if (err == ErrorCodeType.errInvalidToken ||
        err == ErrorCodeType.errTokenExpired) {
      if (_channel == null || _tearingDown) return;

      try {
        debugPrint("🔑 Getting fresh token due to error: $err");
        final newToken = await fetchAgoraToken(
          token: AppUrl.token,
          channelName: _channel!,
          uid: _uid,
          role: isAudience ? 'subscriber' : 'publisher',
        );

        if (newToken?.isNotEmpty == true && engine != null) {
          _currentToken = newToken;

          // Try to renew first
          try {
            await engine?.renewToken(newToken!);
            debugPrint("✅ Token renewed after error");
          } catch (renewError) {
            debugPrint("🔁 Renew failed, attempting rejoin: $renewError");

            // If renew fails, try rejoin
            try {
              await engine?.leaveChannel();
              await Future.delayed(const Duration(milliseconds: 500));

              await engine?.joinChannel(
                token: newToken!,
                channelId: _channel!,
                uid: _uid,
                options: ChannelMediaOptions(
                  channelProfile:
                      ChannelProfileType.channelProfileLiveBroadcasting,
                  clientRoleType: isAudience
                      ? ClientRoleType.clientRoleAudience
                      : ClientRoleType.clientRoleBroadcaster,
                  publishMicrophoneTrack: !isAudience,
                  publishCameraTrack: !isAudience,
                  autoSubscribeAudio: true,
                  autoSubscribeVideo: true,
                ),
              );
              debugPrint("✅ Successfully rejoined with fresh token");
            } catch (rejoinError) {
              debugPrint("❌ Rejoin failed: $rejoinError");
              Get.snackbar("Error", "Connection failed. Please try again.");
            }
          }
        } else {
          debugPrint("❌ Could not get fresh token");
          Get.snackbar("Error", "Unable to refresh connection.");
        }
      } catch (e) {
        debugPrint("Token error handling failed: $e");
        Get.snackbar("Error", "Connection error: $e");
      }
    }
  }

  Future<void> leaveChannel() async {
    if (engine == null || _tearingDown) return;
    _tearingDown = true;

    debugPrint("🚪 Leaving channel...");
    try {
      // Stop local streams first
      await engine?.enableLocalVideo(false);
      await engine?.enableLocalAudio(false);
      await engine?.stopPreview();

      // Leave channel
      await engine?.leaveChannel();

      // Give some time for cleanup
      await Future.delayed(const Duration(milliseconds: 300));

      // Unregister handler
      if (_handler != null) {
        engine?.unregisterEventHandler(_handler!);
      }

      // Release engine
      await engine?.release();

      debugPrint("✅ Successfully left channel");
    } catch (e) {
      debugPrint("❌ leaveChannel error: $e");
    } finally {
      engine = null;
      _handler = null;
      remoteUid.value = null;
      _currentCallId = null;
      _tearingDown = false;
    }
  }

  void muteUnmute() {
    if (_tearingDown || engine == null) return;
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
    debugPrint("🎤 Mute: ${isMuted.value}");
  }

  void switchCamera() {
    if (_tearingDown || engine == null) return;
    engine?.switchCamera();
    debugPrint("📷 Camera switched");
  }

  // ================== API CALLS ==================

  Future<Map<String, dynamic>?> startCall(String token) async {
    try {
      isLoading.value = true;
      debugPrint("📞 Starting call...");

      final res = await http.post(
        Uri.parse(AppUrl.startVideoCall),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("📞 Start call response: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("📞 Call start response: $data");

        // Cache server appId
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;

        // Get call details
        final callId = data['call']?['id']?.toString() ?? '';
        final channelFromApi =
            data['agora']?['channelName'] ?? data['call']?['room_id'] ?? '';
        final callerToken = data['agora']?['token'] ?? '';

        // Emit call started event to notify ALL live hosts
        SocketService.to.notifyCallStarted({
          "callId": callId,
          "callerId": AppUrl.riolive_id.toString(),
          "callerName": AppUrl.user_name ?? "Unknown",
          "channel": channelFromApi,
          "channelName": channelFromApi,
          "roomId": channelFromApi,
          "roomName": channelFromApi,
          "callerToken": callerToken,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        });

        debugPrint("📤 Emitted call_started event");
        return data;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ Start call failed: ${body['message']}");
        Get.snackbar("Error", body['message'] ?? "Start call failed");
      }
    } catch (e) {
      debugPrint("❌ Start call error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    try {
      isLoading.value = true;
      debugPrint("🤝 Joining call: $callId");

      final res = await http.post(
        Uri.parse("${AppUrl.joinVideoCall}$callId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("🤝 Join call response: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("🤝 Join call data: $data");

        // Cache server appId
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;

        return data;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ Join call failed: ${body['message']}");
        Get.snackbar("Error", body['message'] ?? "Join call failed");
      }
    } catch (e) {
      debugPrint("❌ Join call error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> endCall(String token, String callId) async {
    if (_tearingDown) return false;

    try {
      debugPrint("☎️ Ending call: $callId");

      // First leave the Agora channel
      await leaveChannel();

      // Then notify server
      final res = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("☎️ End call response: ${res.statusCode}");

      if (res.statusCode == 200) {
        // Notify via socket that call ended
        SocketService.to.notifyCallEnded({
          "callId": callId,
          "userId": AppUrl.riolive_id.toString(),
          "timestamp": DateTime.now().millisecondsSinceEpoch,
        });

        debugPrint("✅ Call ended successfully");
        return true;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ End call API failed: ${body['message']}");
        Get.snackbar("Error", body['message'] ?? "End call failed");
      }
    } catch (e) {
      debugPrint("❌ EndCall error: $e");
      Get.snackbar("Error", "Failed to end call: $e");
    }
    return false;
  }

  Future<Map<String, dynamic>?> startLiveCall(String token) async {
    try {
      isLoading.value = true;
      debugPrint("🔴 Starting live stream...");

      final res = await http.post(
        Uri.parse(AppUrl.goLiveCall),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("🔴 Live call response: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("🔴 Live call data: $data");

        // Cache server appId
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;
        _isLiveHost = true;

        return data;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ Start live failed: ${body['message']}");
        Get.snackbar("Error", body['message'] ?? "Start live failed");
      }
    } catch (e) {
      debugPrint("❌ Start live error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<List<dynamic>> getLiveHosts(String token) async {
    try {
      final res = await http.get(
        Uri.parse(AppUrl.liveListCall),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['hosts'] as List?) ?? [];
      }
    } catch (e) {
      debugPrint("Get live hosts error: $e");
    }
    return [];
  }

  Future<String?> fetchAgoraToken({
    required String token,
    required String channelName,
    required int uid,
    String role = 'publisher',
  }) async {
    try {
      debugPrint(
        "🔑 Fetching token for channel: $channelName, uid: $uid, role: $role",
      );

      final uri = Uri.parse(
        "${AppUrl.agoraToken}?channel=$channelName&uid=$uid&role=$role",
      );
      final res = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("🔑 Token response: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final agoraToken = (data['agora']?['token'] ?? data['token'])
            ?.toString();
        debugPrint("🔑 Got token: ${agoraToken?.substring(0, 20)}...");
        return agoraToken;
      } else {
        debugPrint("❌ Token fetch failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ fetchAgoraToken error: $e");
    }
    return null;
  }

  // Helper method to end live stream
  Future<bool> endLiveStream(String token) async {
    try {
      debugPrint("🔴 Ending live stream...");

      // Leave channel first
      await leaveChannel();

      // You might need an API endpoint to end live stream
      // Add your end live stream API call here if available

      _isLiveHost = false;
      debugPrint("✅ Live stream ended");
      return true;
    } catch (e) {
      debugPrint("❌ End live stream error: $e");
      return false;
    }
  }

  // Getter for current call state
  bool get isInCall => engine != null && _channel != null;
  bool get isLiveHost => _isLiveHost;
  String? get currentCallId => _currentCallId;

  @override
  void onClose() {
    debugPrint("🧹 CallController disposing...");
    leaveChannel();
    super.onClose();
  }
}
