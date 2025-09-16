import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_circle.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../../../controller/random_call_controller.dart';
import '../../../../../services/socket_service.dart';
import '../../../../../utile/app_url.dart';
import '../call_screen/video_call_screen/video_call_screen.dart';

class MatchTab extends StatefulWidget {
  final String token;
  const MatchTab({super.key, required this.token});

  @override
  State<MatchTab> createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> {
  final CallController callController = Get.put(CallController());

  @override
  void initState() {
    super.initState();
    // Initialize socket connection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SocketService.to.initSocket(widget.token, AppUrl.riolive_id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive helper
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final scaleFactor = size.width / 390; // Base width 390px
    
    // ✅ More aggressive scaling for CustomCircle on smaller screens
    double circleScaleFactor;
    if (size.width < 350) {
      // Very small screens - scale down more
      circleScaleFactor = scaleFactor * 0.7;
    } else if (size.width < 400) {
      // Small screens - moderate scale down
      circleScaleFactor = scaleFactor * 0.8;
    } else {
      // Regular and large screens - normal scaling
      circleScaleFactor = scaleFactor;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Spacer(flex: 1),
          CustomCircle(
            centerImg: 'assets/images/girl_img2.png',
            topLeftImg: 'assets/images/profile.png',
            topRightImg: 'assets/images/profile12.png',
            centerLeftImg: 'assets/images/profile.jpg',
            centerRightImg: 'assets/images/story_0.png',
            bottomLeftImg: 'assets/images/story_1.jpg',
            bottomRightImg: 'assets/images/girl_img1.png',
            scaleFactor: circleScaleFactor, // ✅ Use circle-specific scale factor
          ),
          Spacer(flex: 1),
          CustomText(
            'Match Random Video Call',
            color: const Color(0xff5EBFEF),
            fontSize: isTablet ? 32 : (size.width < 350 ? 22 : 26) * scaleFactor,
            fontWeight: FontWeight.bold,
            fontType: AppFont.poppins,
          ),
          SizedBox(height: (size.width < 350 ? 12 : 20) * scaleFactor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/icons/diamondicon.png'),
                height: (size.width < 350 ? 16 : 20) * scaleFactor,
                width: (size.width < 350 ? 21 : 27) * scaleFactor,
              ),
              CustomText(
                '800/min',
                color: const Color(0xff60ED59),
                fontSize: isTablet ? 32 : (size.width < 350 ? 22 : 26) * scaleFactor,
                fontWeight: FontWeight.bold,
                fontType: AppFont.poppins,
              ),
            ],
          ),
          SizedBox(height: (size.width < 350 ? 12 : 20) * scaleFactor),
          // Socket connection status indicator
          Obx(() {
            final status = SocketService.to.connectionStatus.value;
            Color statusColor;

            switch (status) {
              case 'connected':
                statusColor = Colors.green;
                break;
              case 'connecting':
                statusColor = Colors.orange;
                break;
              case 'error':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.grey;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: statusColor, size: 12 * scaleFactor),
                SizedBox(width: 8 * scaleFactor),
                CustomText(
                  'Status: ${status.toUpperCase()}',
                  color: Colors.white,
                  fontSize: isTablet ? 16 : (size.width < 350 ? 12 : 14) * scaleFactor,
                ),
              ],
            );
          }),
          Spacer(flex: 1),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                // Get.to(() => UserVideoCallScreen());
                try {
                  if (!SocketService.to.isConnected.value) {
                    Get.snackbar(
                      "Connection Error",
                      "Please wait for socket connection",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  final response = await callController.startCall(widget.token);
                  if (response != null && Get.isDialogOpen == true) {
                    Get.back();
                  }

                  if (response == null) {
                    Get.snackbar("Error", "Failed to start call");
                    return;
                  }

                  final callId = response['call']?['id']?.toString() ?? '';
                  final channelName =
                      response['agora']?['channelName']?.toString() ?? '';
                  final agoraToken =
                      response['agora']?['token']?.toString() ?? '';

                  if (callId.isEmpty ||
                      channelName.isEmpty ||
                      agoraToken.isEmpty) {
                    Get.snackbar("Error", "Invalid call data received");
                    return;
                  }

                  // Use the improved socket service
                  SocketService.to.notifyCallStarted({
                    "callId": callId,
                    "channelName": channelName,
                    "token": agoraToken,
                  });

                  Get.to(
                    () => VideoCallScreen(
                      token: widget.token,
                      callId: callId,
                      channelName: channelName,
                      agoraToken: agoraToken,
                      isHost: false,
                    ),
                  );
                } catch (e) {
                  if (Get.isDialogOpen == true) Get.back();
                  Get.snackbar("Error", "Failed to start call: $e");
                  debugPrint("Error starting call: $e");
                }
              },
              child: Container(
                height: (isTablet ? 100 : size.width < 350 ? 70 : 80) * scaleFactor,
                width: (isTablet ? 100 : size.width < 350 ? 70 : 80) * scaleFactor,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all((size.width < 350 ? 6 : 8) * scaleFactor),
                child: Image.asset(
                  'assets/icons/phoneicon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Spacer(flex: 3),
          // // Debug button (remove in production)
          // TextButton(
          //   onPressed: () {
          //     SocketService.to.debugSocketStatus();
          //   },
          //   child: const Text(
          //     "Debug Socket",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
