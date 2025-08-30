import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../utile/app_url.dart';
import '../views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';

class CallController extends GetxController {
  static const String appId =
      "6660b35538257de9b67a8b7e6926e1"; // From API response

  var isLoading = false.obs;
  RtcEngine? engine;
  var remoteUid = RxnInt();
  var isReady = false.obs;
  var isMuted = false.obs;
  Timer? _pollingTimer;

  // Init Agora
  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
  }) async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine?.initialize(RtcEngineContext(appId: appId));

    engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          isReady.value = true;
        },
        onUserJoined: (connection, uid, elapsed) {
          remoteUid.value = uid;
        },
        onUserOffline: (connection, uid, reason) {
          remoteUid.value = null;
        },
        onError: (error, msg) {
          debugPrint("Agora Error: $error, $msg");
        },
      ),
    );

    await engine?.enableVideo();
    await engine?.startPreview();

    await engine?.joinChannel(
      token: agoraToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
    engine = null;
    isReady.value = false;
    remoteUid.value = null;
  }

  void muteUnmute() {
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
  }

  void switchCamera() {
    engine?.switchCamera();
  }

  /// Start Random Call API
  Future<Map<String, dynamic>?> startCall(String token) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(AppUrl.startVideoCall),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar("Error", "Failed to start call: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Start Live Stream API
  Future<Map<String, dynamic>?> startLiveCall(String token) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(AppUrl.goLiveCall),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar("Error", "Failed to start live: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Join Call API
  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse("${AppUrl.joinVideoCall}$callId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar("Error", "Failed to join call: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// End Call API
  Future<bool> endCall(String token, String callId) async {
    try {
      final response = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("EndCall error: $e");
      return false;
    }
  }

  /// Check for live hosts
  Future<List<dynamic>> getLiveHosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrl.liveListCall),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['hosts'] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint("Get live hosts error: $e");
      return [];
    }
  }

  /// Poll for incoming calls (for hosts)
  void startPollingForIncomingCalls(String token) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final response = await http.get(
          Uri.parse(AppUrl.lastestVideoCall),
          headers: {"Authorization": "Bearer $token"},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['incoming'] == true) {
            // Show incoming call dialog
            showIncomingCallDialog(token, data);
          }
        }
      } catch (e) {
        debugPrint("Polling error: $e");
      }
    });
  }

  void showIncomingCallDialog(String token, Map<String, dynamic> data) {
    // Cancel polling when dialog is shown
    _pollingTimer?.cancel();

    final callId = data['callId'].toString();
    final callerName = data['callerName'] ?? "Random User";

    Get.dialog(
      AlertDialog(
        title: const Text("Incoming Call"),
        content: Text("You have a call from $callerName"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              // Resume polling after rejection
              startPollingForIncomingCalls(token);
            },
            child: const Text("Reject"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              // Join the call
              final joinData = await joinCall(token, callId);
              if (joinData != null) {
                final channelName = joinData['agora']['channelName'];
                final agoraToken =
                    joinData['agora']['callerToken'] ??
                    joinData['agora']['token'];

                Get.to(
                  () => VideoCallScreen(
                    token: token,
                    callId: callId,
                    channelName: channelName,
                    agoraToken: agoraToken,
                  ),
                );
              }
            },
            child: const Text("Accept"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}
