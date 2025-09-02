import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../socket/incoming_calls.dart';
import '../utile/app_url.dart';

class CallController extends GetxController {
  static const String fallbackAppId = "747241138f01491291af0d34b78a5e9c";

  var isLoading = false.obs;
  RtcEngine? engine;
  var remoteUid = RxnInt();
  var isMuted = false.obs;

  String? channel;
  String? _currentToken;
  String? _serverAppId;
  int _uid = 0;
  bool _tearingDown = false;
  RtcEngineEventHandler? _handler;

  int _deriveUid() {
    final parsed = int.tryParse(AppUrl.riolive_id.toString());
    return parsed ?? 0;
  }

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
    bool isHost = false,
    bool isAudience = false,
    required String callId,
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

      channel = channelName;
      _currentToken = agoraToken;
      _uid = _deriveUid();

      engine = createAgoraRtcEngine();
      final appIdToUse = _serverAppId ?? fallbackAppId;
      await engine!.initialize(RtcEngineContext(appId: appIdToUse));

      await engine!.setDefaultAudioRouteToSpeakerphone(true);
      await engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 960, height: 540),
          frameRate: 15,
        ),
      );

      await engine!.enableVideo();
      await engine!.enableLocalVideo(!isAudience);

      _handler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          debugPrint(
            "✅ Joined ${connection.channelId} uid=${connection.localUid}",
          );
          if (!isAudience) {
            await engine?.enableLocalVideo(true);
            await engine?.startPreview();
            await engine?.setupLocalVideo(
              const VideoCanvas(
                uid: 0,
                sourceType: VideoSourceType.videoSourceCamera,
              ),
            );
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
        onRequestToken: (RtcConnection _) {
          _handleTokenRefreshRequest(isAudience);
        },
        onTokenPrivilegeWillExpire: (RtcConnection _, String __) {
          _handleTokenRefreshRequest(isAudience);
        },
        onError: (ErrorCodeType err, String msg) {
          _handleAgoraError(err, isAudience);
        },
      );
      engine!.registerEventHandler(_handler!);

      await engine!.joinChannel(
        token: _currentToken!,
        channelId: channel!,
        uid: _uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: isAudience
              ? ClientRoleType.clientRoleAudience
              : ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      debugPrint("Agora init error: $e");
      Get.snackbar("Error", "Agora init failed: $e");
    }
  }

  void _handleTokenRefreshRequest(bool isAudience) async {
    if (channel == null) return;
    try {
      final newToken = await fetchAgoraToken(
        token: AppUrl.token,
        channelName: channel!,
        uid: _uid,
        role: isAudience ? 'subscriber' : 'publisher',
      );
      if (newToken?.isNotEmpty == true) {
        _currentToken = newToken;
        await engine?.renewToken(newToken!);
      }
    } catch (e) {
      debugPrint("Token refresh error: $e");
    }
  }

  void _handleAgoraError(ErrorCodeType err, bool isAudience) async {
    debugPrint("Agora error [$err]");
    if (err == ErrorCodeType.errInvalidToken ||
        err == ErrorCodeType.errTokenExpired) {
      if (channel == null) return;
      try {
        final newToken = await fetchAgoraToken(
          token: AppUrl.token,
          channelName: channel!,
          uid: _uid,
          role: isAudience ? 'subscriber' : 'publisher',
        );
        if (newToken?.isNotEmpty == true) {
          _currentToken = newToken;
          await engine?.renewToken(newToken!);
          try {
            await engine?.leaveChannel();
          } catch (_) {}
          await engine?.joinChannel(
            token: newToken!,
            channelId: channel!,
            uid: _uid,
            options: ChannelMediaOptions(
              channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
              clientRoleType: isAudience
                  ? ClientRoleType.clientRoleAudience
                  : ClientRoleType.clientRoleBroadcaster,
            ),
          );
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
      await engine?.stopPreview();
      await engine?.enableLocalVideo(false);
      await engine?.leaveChannel();
      await Future.delayed(const Duration(milliseconds: 300));
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
      isLoading.value = true;
      final res = await http.post(
        Uri.parse(AppUrl.startVideoCall),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;

        return data;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "Start call failed");
      }
    } catch (e) {
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

  Future<List<Map<String, dynamic>>> getLiveHosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/hosts/live-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['hosts'] != null) {
          final hosts = List<Map<String, dynamic>>.from(data['hosts']);
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
    String role = 'host',
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
        if (data['status'] == 'success' && data['agora'] != null) {
          return data['agora']['token']?.toString();
        }
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
