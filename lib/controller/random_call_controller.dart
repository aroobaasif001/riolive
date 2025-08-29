import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../utile/app_url.dart';

class CallController extends GetxController {
  static const String appId = "747241138f01491291af0d34b78a5e9c";

  RtcEngine? engine;

  // Reactive states
  var remoteUid = RxnInt(); // nullable int
  var isReady = false.obs;
  var isMuted = false.obs;

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
        onUserJoined: (connection, uid, elapsed) {
          remoteUid.value = uid;
        },
        onUserOffline: (connection, uid, reason) {
          remoteUid.value = null;
        },
      ),
    );

    await engine?.enableVideo();
    await engine?.startPreview();

    await engine?.joinChannel(
      token: agoraToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    isReady.value = true;
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
    engine = null;
    isReady.value = false;
    remoteUid.value = null;
  }

  // ---- Extra Features ----
  void muteUnmute() {
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
  }

  void switchCamera() {
    engine?.switchCamera();
  }

  // ---- API Start Call ----
  Future<Map<String, dynamic>?> startCall(String token) async {
    final res = await http.post(
      Uri.parse(AppUrl.startVideoCall),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  // ---- API Join Call ----
  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    final res = await http.post(
      Uri.parse("${AppUrl.joinVideoCall}$callId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  // ---- End Call ----
  Future<bool> endCall(String token, String callId) async {
    try {
      final res = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint("EndCall error: $e");
      return false;
    }
  }
}
