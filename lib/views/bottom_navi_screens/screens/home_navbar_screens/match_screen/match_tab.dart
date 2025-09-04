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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 30),
          CustomCircle(
            centerImg: 'assets/images/girl_img2.png',
            topLeftImg: 'assets/images/girl_img2.png',
            topRightImg: 'assets/images/girl_img2.png',
            centerLeftImg: 'assets/images/girl_img2.png',
            centerRightImg: 'assets/images/girl_img2.png',
            bottomLeftImg: 'assets/images/girl_img2.png',
            bottomRightImg: 'assets/images/girl_img2.png',
          ),
          const SizedBox(height: 30),
          const CustomText(
            'Match Random Video Call',
            color: Color(0xff5EBFEF),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontType: AppFont.poppins,
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
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
                Icon(Icons.circle, color: statusColor, size: 12),
                const SizedBox(width: 8),
                CustomText(
                  'Status: ${status.toUpperCase()}',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
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
