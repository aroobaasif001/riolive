import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/random_call_controller.dart';
import '../../../../utile/app_url.dart';
import '../home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart'
    hide CallController;

class StartCallDummyScreen extends StatelessWidget {
  const StartCallDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callController = Get.put(CallController());

    return Scaffold(
      appBar: AppBar(title: const Text("Start Call")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final response = await callController.startLiveCall(AppUrl.token);
            if (response != null) {
              final callId = response['host']['id'];
              final channelName = response['agora']['channelName'];
              final agoraToken = response['agora']['token'];
              // final agoraAppId = response['agora']['appId'];

              Get.to(
                () => VideoCallScreen(
                  token: AppUrl.token,
                  callId: callId,
                  channelName: channelName,
                  agoraToken: agoraToken,
                  // appId: agoraAppId,
                ),
              );
            } else {
              Get.snackbar("Error", "Failed to start call");
            }
          },
          child: const Text("Start Live Call"),
        ),
      ),
    );
  }
}
