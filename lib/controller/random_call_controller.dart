import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../utile/app_url.dart';

class CallController {
  static const String appId =
      "747241138f01491291af0d34b78a5e9c"; // Replace with Agora App ID
  RtcEngine? engine;

  Future<bool> endCall(String token, String callId) async {
    try {
      final res = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("EndCall status: ${res.statusCode}");
      debugPrint("EndCall body: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      debugPrint("EndCall error: $e");
      return false;
    }
  }

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
    required Function(int) onRemoteJoined,
    required Function(int) onRemoteLeft,
  }) async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine?.initialize(RtcEngineContext(appId: appId));

    engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("Local joined: ${connection.channelId}");
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("Remote user joined: $remoteUid");
          onRemoteJoined(remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("Remote left: $remoteUid");
          onRemoteLeft(remoteUid);
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
  }

  Future<void> leaveChannel() async {
    await engine?.leaveChannel();
    await engine?.release();
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
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
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
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }
}
