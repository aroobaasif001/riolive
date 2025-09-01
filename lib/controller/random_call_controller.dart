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

  int _deriveUid() {
    final parsed = int.tryParse(AppUrl.riolive_id.toString());
    return parsed ?? 0; // if your server signs uid=0, keep it 0
  }

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
    bool isHost = false, // kept for API compatibility
    bool isAudience = false,
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
      _uid = _deriveUid(); // must match server-signed uid

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
          remoteUid.value = uid;
        },
        onUserOffline: (RtcConnection _, int uid, UserOfflineReasonType __) {
          remoteUid.value = null;
        },
        onLeaveChannel: (RtcConnection _, RtcStats __) {
          remoteUid.value = null;
        },

        // Some SDK variants call this when they need a new token.
        onRequestToken: (RtcConnection connection) {
          _handleTokenRefreshRequest(isAudience);
        },

        // Correct signature: (RtcConnection, String)
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          _handleTokenRefreshRequest(isAudience);
        },

        // Handle invalid/expired token paths
        onError: (ErrorCodeType err, String msg) {
          _handleAgoraError(err, isAudience);
        },
      );
      engine!.registerEventHandler(_handler!);

      await engine!.joinChannel(
        token: _currentToken!,
        channelId: _channel!,
        uid: _uid, // MUST match token
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: isAudience
              ? ClientRoleType.clientRoleAudience
              : ClientRoleType.clientRoleBroadcaster, // 1-to-1 => broadcaster
        ),
      );
    } catch (e) {
      debugPrint("Agora init error: $e");
      Get.snackbar("Error", "Agora init failed: $e");
    }
  }

  // ---- Helper: Token refresh on request/privilege-will-expire
  void _handleTokenRefreshRequest(bool isAudience) async {
    if (_channel == null) return;
    try {
      final newToken = await fetchAgoraToken(
        token: AppUrl.token,
        channelName: _channel!,
        uid: _uid,
        role: isAudience ? 'subscriber' : 'publisher',
      );
      if (newToken?.isNotEmpty == true) {
        _currentToken = newToken;
        await engine?.renewToken(newToken!);
        debugPrint("🔄 Token renewed (requested/expiring)");
      }
    } catch (e) {
      debugPrint("Token refresh error: $e");
    }
  }

  // ---- Helper: Error handling, including invalid/expired token
  void _handleAgoraError(ErrorCodeType err, bool isAudience) async {
    debugPrint("Agora error [$err]");
    if (err == ErrorCodeType.errInvalidToken ||
        err == ErrorCodeType.errTokenExpired) {
      if (_channel == null) return;
      try {
        final newToken = await fetchAgoraToken(
          token: AppUrl.token,
          channelName: _channel!,
          uid: _uid,
          role: isAudience ? 'subscriber' : 'publisher',
        );
        if (newToken?.isNotEmpty == true) {
          _currentToken = newToken;
          // Renew and safe re-join to cover early join failure as well
          await engine?.renewToken(newToken!);
          try {
            await engine?.leaveChannel();
          } catch (_) {}
          await engine?.joinChannel(
            token: newToken!,
            channelId: _channel!,
            uid: _uid,
            options: ChannelMediaOptions(
              channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
              clientRoleType: isAudience
                  ? ClientRoleType.clientRoleAudience
                  : ClientRoleType.clientRoleBroadcaster,
            ),
          );
          debugPrint("🔁 Re-joined with fresh token");
        } else {
          Get.snackbar("Error", "Unable to refresh Agora token.");
        }
      } catch (e) {
        debugPrint("Token error handling failed: $e");
      }
    }
  }

  Future<void> leaveChannel() async {
    if (engine == null || _tearingDown) return;
    _tearingDown = true;
    try {
      await engine?.enableLocalVideo(false);
      await engine?.stopPreview();
      await engine?.leaveChannel();
      await Future.delayed(
        const Duration(milliseconds: 150),
      ); // let Camera2 finish callbacks
      if (_handler != null) {
        engine?.unregisterEventHandler(_handler!);
      }
      await engine?.release();
    } catch (e) {
      debugPrint("leaveChannel error: $e");
    } finally {
      engine = null;
      _handler = null;
      remoteUid.value = null;
      _tearingDown = false;
    }
  }

  void muteUnmute() {
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
  }

  void switchCamera() {
    if (_tearingDown) return;
    engine?.switchCamera();
  }

  // ================== API CALLS ==================

  Future<Map<String, dynamic>?> startCall(String token) async {
    try {
      debugPrint("🚀 startCall() - Making API request...");
      debugPrint("🔍 API URL: ${AppUrl.startVideoCall}");
      debugPrint("🔍 Token: ${token.isNotEmpty ? "Present" : "Missing"}");

      isLoading.value = true;
      final res = await http.post(
        Uri.parse(AppUrl.startVideoCall),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("🔍 API Response Status: ${res.statusCode}");
      debugPrint("🔍 API Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("✅ call start success: $data");

        // cache server appId (CRITICAL for token-appId match)
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;
        debugPrint("🔍 Server App ID: $_serverAppId");

        // Resolve common fields from response
        final callId = data['call']?['id'];
        final channelFromApi =
            data['agora']?['channelName'] ?? data['call']?['room_id'];
        final callerToken =
            data['agora']?['callerToken'] ?? data['agora']?['token'];

        debugPrint("🔍 Extracted data:");
        debugPrint("   Call ID: $callId");
        debugPrint("   Channel: $channelFromApi");
        debugPrint(
          "   Caller Token: ${callerToken?.toString().isNotEmpty == true ? "Present" : "Missing"}",
        );

        // Prepare socket payload
        final socketPayload = {
          "callId": callId,
          "callerId": AppUrl.riolive_id,
          "callerName": AppUrl.user_name,
          // synonyms for channel/room
          "channel": channelFromApi,
          "channelName": channelFromApi,
          "roomId": channelFromApi,
          "roomName": channelFromApi,
          // pass caller side token if your server wants to forward it
          "callerToken": callerToken,
        };

        debugPrint("📡 Emitting call_started socket event...");
        debugPrint("🔍 Socket payload: $socketPayload");

        // Emit with synonym keys so backend listener doesn't miss it
        SocketService.to.notifyCallStarted(socketPayload);

        debugPrint("✅ Socket event emitted successfully");
        return data;
      } else {
        debugPrint("❌ API Error - Status: ${res.statusCode}");
        final body = jsonDecode(res.body);
        debugPrint("❌ Error body: $body");
        Get.snackbar("Error", body['message'] ?? "Start call failed");
      }
    } catch (e) {
      debugPrint("❌ startCall() Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse("${AppUrl.joinVideoCall}$callId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("join call: $data");

        // cache server appId
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;

        return data;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "Join call failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> endCall(String token, String callId) async {
    try {
      final res = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        SocketService.to.notifyCallEnded({
          "callId": callId,
          "userId": AppUrl.riolive_id,
        });
        return true;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "End call failed");
      }
    } catch (e) {
      debugPrint("EndCall error: $e");
    }
    return false;
  }

  Future<Map<String, dynamic>?> startLiveCall(String token) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse(AppUrl.goLiveCall),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        // cache server appId
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;

        return data;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "Start live failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  // Your live-list response: {"status":"success","count":2,"hosts":[{...}]}
  Future<List<Map<String, dynamic>>> getLiveHosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/hosts/live-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint(
        '🔍 Fetching live hosts from: ${AppUrl.baseUrl}/api/hosts/live-list',
      );
      debugPrint('🔍 Live hosts API response status: ${response.statusCode}');
      debugPrint('🔍 Live hosts API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success' && data['hosts'] != null) {
          final hosts = List<Map<String, dynamic>>.from(data['hosts']);
          debugPrint('🔍 Parsed hosts count: ${hosts.length}');

          if (hosts.isNotEmpty) {
            debugPrint('🔍 First host data structure: ${hosts.first}');
          }

          return hosts;
        }
      }

      return [];
    } catch (e) {
      debugPrint('❌ Error fetching live hosts: $e');
      return [];
    }
  }

  Future<String?> fetchAgoraToken({
    required String token,
    required String channelName,
    required int uid,
    String role = 'publisher', // 'publisher' for 1:1, 'subscriber' for viewer
  }) async {
    try {
      final uri = Uri.parse(
        "${AppUrl.agoraToken}?channel=$channelName&uid=$uid&role=$role",
      );
      final res = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['agora']?['token'] ?? data['token'])?.toString();
      }
    } catch (e) {
      debugPrint("fetchAgoraToken error: $e");
    }
    return null;
  }

  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }
}
