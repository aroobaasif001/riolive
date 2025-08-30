import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_circle.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart'
    hide CallController;

import '../../../../../controller/random_call_controller.dart';

class MatchScreen extends StatelessWidget {
  final String token;
  MatchScreen({super.key, required this.token});

  final CallController _callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 50),
          CustomCircle(
            centerImg: 'assets/images/girl_img2.png',
            topLeftImg: 'assets/images/girl_img2.png',
            topRightImg: 'assets/images/girl_img2.png',
            centerLeftImg: 'assets/images/girl_img2.png',
            centerRightImg: 'assets/images/girl_img2.png',
            bottomLeftImg: 'assets/images/girl_img2.png',
            bottomRightImg: 'assets/images/girl_img2.png',
          ),
          const SizedBox(height: 40),
          const CustomText(
            'Match Random Video Call',
            color: Color(0xff5EBFEF),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontType: AppFont.poppins,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage('assets/icons/diamondicon.png'),
                height: 20,
                width: 27,
              ),
              CustomText(
                '800/min',
                color: Color(0xff60ED59),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontType: AppFont.poppins,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                // First check if there are any live hosts
                final liveHosts = await _callController.getLiveHosts(token);

                if (liveHosts.isNotEmpty) {
                  // Show dialog to join live stream instead
                  Get.dialog(
                    AlertDialog(
                      title: const Text("Live Stream Available"),
                      content: const Text(
                        "There are live streams available. Do you want to join a live stream instead of starting a random call?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Get.back();
                            // Start random call
                            await startRandomCall();
                          },
                          child: const Text("Random Call"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            // Join the first live stream
                            final host = liveHosts[0];
                            joinLiveStream(host);
                          },
                          child: const Text("Join Live"),
                        ),
                      ],
                    ),
                  );
                } else {
                  // No live hosts, start random call directly
                  await startRandomCall();
                }
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/icons/phoneicon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startRandomCall() async {
    final response = await _callController.startCall(token);
    if (response != null) {
      final callId = response['call']['id'].toString();
      final channelName = 'test'; // You might need to adjust this
      final agoraToken = response['agora']['callerToken'];

      Get.to(
        () => VideoCallScreen(
          token: token,
          callId: callId,
          channelName: channelName,
          agoraToken: agoraToken,
        ),
      );
    } else {
      Get.snackbar("Error", "Failed to start call");
    }
  }

  void joinLiveStream(Map<String, dynamic> host) {
    // For live streams, you might need a different API endpoint
    // This is a placeholder implementation
    final hostId = host['id'].toString();
    final channelName = 'live_$hostId';

    // In a real scenario, you would get the token from your backend
    Get.to(
      () => VideoCallScreen(
        token: token,
        callId: hostId,
        channelName: channelName,
        agoraToken: "placeholder_token", // You need to implement this
      ),
    );
  }
}
