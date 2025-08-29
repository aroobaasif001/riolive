import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_circle.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';

import '../../../../../controller/random_call_controller.dart';

class MatchScreen extends StatelessWidget {
  final String token; // 👈 pass login token
  MatchScreen({super.key, required this.token});

  final CallController _callController = CallController();

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
                final response = await _callController.startCall(token);
                print(response);
                if (response != null) {
                  final callId = response['call']['id'].toString();
                  print(callId);
                  final channelName = 'test';

                  ///response['channelName']
                  final agoraToken = response['agora']['callerToken'];
                  print(agoraToken);

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
}
