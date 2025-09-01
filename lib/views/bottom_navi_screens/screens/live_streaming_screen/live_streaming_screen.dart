import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/random_call_controller.dart';
import '../../../../socket/incoming_calls.dart';
import '../../../../utile/app_url.dart';
import '../home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';

class StartCallDummyScreen extends StatelessWidget {
  const StartCallDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callController = Get.put(CallController());

    return Scaffold(
      appBar: AppBar(title: const Text("Start Live Stream")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final response = await callController.startLiveCall(AppUrl.token);

              if (response == null) {
                Get.snackbar("Error", "Failed to start live stream");
                return;
              }

              final host = response['host'];
              final agora = response['agora'];

              final hostId = host?['id']?.toString() ?? "";
              final roomId = host?['room_id'] ?? "";
              final channelName = agora?['channelName'] ?? "";
              final agoraToken = agora?['token'] ?? "";

              if (hostId.isEmpty ||
                  roomId.isEmpty ||
                  channelName.isEmpty ||
                  agoraToken.isEmpty) {
                Get.snackbar("Error", "Invalid live stream data from server.");
                return;
              }

              // If backend expects only hostId for 'host_join'
              SocketService.to.hostJoin(hostId);

              Get.to(
                () => VideoCallScreen(
                  token: AppUrl.token,
                  callId: hostId,
                  channelName: channelName,
                  agoraToken: agoraToken,
                  isHost: true,
                ),
              );
            } catch (e) {
              debugPrint("Start live error: $e");
              Get.snackbar("Error", "Live stream error: $e");
            }
          },
          child: const Text("Start Live Stream"),
        ),
      ),
    );
  }
}
