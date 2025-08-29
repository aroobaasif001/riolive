import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/random_call_controller.dart';

class VideoCallScreen extends StatelessWidget {
  final String token;
  final String callId;
  final String channelName;
  final String agoraToken;

  VideoCallScreen({
    super.key,
    required this.token,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
  });

  final CallController controller = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    controller.initAgora(channelName: channelName, agoraToken: agoraToken);

    return Obx(() {
      if (!controller.isReady.value || controller.engine == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Remote user
              controller.remoteUid.value != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine!,
                        canvas: VideoCanvas(uid: controller.remoteUid.value),
                        connection: RtcConnection(channelId: channelName),
                      ),
                    )
                  : const Center(child: Text("Waiting for remote user...")),

              // Local preview
              Positioned(
                top: 40,
                left: 20,
                width: 120,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: controller.engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),

              // Call controls
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute/Unmute
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () => controller.muteUnmute(),
                      child: Obx(
                        () => Icon(
                          controller.isMuted.value ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // End Call
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        final success = await controller.endCall(token, callId);

                        if (success) {
                          Get.back();
                          Get.snackbar("Call", "Call ended successfully");
                        } else {
                          Get.snackbar("Error", "Failed to end call");
                        }

                        await controller.leaveChannel();
                        Get.back();
                      },
                      child: const Icon(
                        Icons.call_end,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),

                    // Switch Camera
                    FloatingActionButton(
                      backgroundColor: Colors.orange,
                      onPressed: () => controller.switchCamera(),
                      child: const Icon(
                        Icons.cameraswitch,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
