import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riolive/utile/app_url.dart';

import '../../../../controller/host_video_call_controller.dart';
import '../../../../controller/random_call_controller.dart';
import '../../../../customwidgets/custom_container.dart';
import '../../../../customwidgets/custombutton.dart';
import '../../../../customwidgets/customtext.dart';
import '../../../../socket/incoming_calls.dart';
import 'host_start_live_streaming_screen/host_start_live_streaming_screen.dart';

class HostVideoCallScreen extends StatefulWidget {
  const HostVideoCallScreen({super.key});

  @override
  State<HostVideoCallScreen> createState() => _HostVideoCallScreenState();
}

class _HostVideoCallScreenState extends State<HostVideoCallScreen> {
  final callController = Get.put(CallController());

  final controller = Get.put(HostVideoCallController());
  final size = Get.size;
  @override
  void initState() {
    print("init");
    // TODO: implement initState
    super.initState();
    _initAgoraPreview();
  }

  Future<void> _initAgoraPreview() async {
    await callController.leaveChannel();

    final cam = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    if (!cam.isGranted || !mic.isGranted) {
      debugPrint("❌ Camera/Microphone permission denied");
      return;
    }

    try {
      callController.engine = createAgoraRtcEngine();
      await callController.engine!.initialize(
        const RtcEngineContext(appId: CallController.fallbackAppId),
      );

      await callController.engine!.enableVideo();
      await callController.engine!.enableLocalVideo(true);

      await callController.engine!.startPreview(); // ✅
      setState(() {});
    } catch (e) {
      debugPrint("Agora preview init error: $e");
    }
  }

  @override
  void dispose() {
    print("dispose");
    callController.leaveChannel();
    super.dispose();
  }

  void _showFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.wifi_find, color: Colors.white),
                  onPressed: () {
                    SocketService.to.debugSocketStatus();
                    // Test socket connection
                    SocketService.to.socket?.emit("test", {"message": "test"});
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select Filter",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.clear, color: Colors.white),
                title: const Text(
                  "None",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await callController.engine?.setBeautyEffectOptions(
                    enabled: false,
                    options: const BeautyOptions(),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.face_retouching_natural,
                  color: Colors.white,
                ),
                title: const Text(
                  "Smooth Skin",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await callController.engine?.setBeautyEffectOptions(
                    enabled: true,
                    options: const BeautyOptions(
                      lighteningContrastLevel:
                          LighteningContrastLevel.lighteningContrastHigh,
                      lighteningLevel: 0.6,
                      smoothnessLevel: 0.7,
                      rednessLevel: 0.1,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title: const Text(
                  "Brighten",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await callController.engine?.setBeautyEffectOptions(
                    enabled: true,
                    options: const BeautyOptions(
                      lighteningContrastLevel:
                          LighteningContrastLevel.lighteningContrastNormal,
                      lighteningLevel: 0.9,
                      smoothnessLevel: 0.3,
                      rednessLevel: 0.1,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens, color: Colors.white),
                title: const Text(
                  "Add Warmth",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await callController.engine?.setBeautyEffectOptions(
                    enabled: true,
                    options: BeautyOptions(
                      lighteningContrastLevel:
                          LighteningContrastLevel.lighteningContrastLow,
                      lighteningLevel: 0.5,
                      smoothnessLevel: 0.4,
                      rednessLevel: 0.6,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔹 Agora Local Preview
          if (callController.engine != null)
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: callController.engine!,
                canvas: const VideoCanvas(
                  uid: 0,
                  sourceType: VideoSourceType.videoSourceCamera, // 👈 important
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          // // 🔹 Background (replace with your live background image)
          // CustomContainer(
          //   height: size.height,
          //   width: size.width,
          //   image: const DecorationImage(
          //     image: AssetImage("assets/images/hostVideoBg.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // // 🔹 Camera Preview as Background
          // FutureBuilder(
          //   future: _initializeControllerFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return CameraPreview(_cameraController);
          //     } else {
          //       return const Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),

          // 🔹 Overlay content
          SafeArea(
            child: Column(
              children: [
                // Close button ❌
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CloseButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      onPressed: () async {
                        // 👇 stop preview & release engine
                        await callController.engine?.stopPreview();
                        await callController.leaveChannel();
                        Get.back();
                      },
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🦜 Top popup box
                CustomContainer(
                  height: 155,
                  width: size.width * 0.9,
                  borderRadius: BorderRadius.circular(20),
                  conColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Parrot Icon + Edit
                          CustomContainer(
                            width: 110,
                            borderRadius: BorderRadius.circular(15),
                            conColor: Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            child: Column(
                              children: [
                                CustomContainer(
                                  height: 60,
                                  width: 60,
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      "assets/images/parrot.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                CustomContainer(
                                  width: 110,
                                  height: 28,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  conColor: Colors.white.withOpacity(0.3),
                                  child: Center(
                                    child: const CustomText(
                                      textAlign: TextAlign.center,
                                      "Edit",
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Middle column: title + public/private
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText(
                                  "Add a title to chat",
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: 10),

                                // Toggle Button (Public / Private)
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => controller.isPublic.value =
                                        !controller.isPublic.value,
                                    child: CustomContainer(
                                      height: 32,
                                      width: 110,
                                      borderRadius: BorderRadius.circular(20),
                                      conColor: Colors.white.withOpacity(0.3),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),

                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // 👥 or 🔒 Icon Image
                                          Image.asset(
                                            controller.isPublic.value
                                                ? "assets/icons/group.png" // 👥
                                                : "assets/icons/group.png", // 🔒
                                            height: 18,
                                            width: 18,
                                          ),
                                          const SizedBox(width: 6),

                                          // Public / Private text
                                          CustomText(
                                            controller.isPublic.value
                                                ? "Public"
                                                : "Private",
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      // Hashtag Text
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: const CustomText(
                          "#Virtual Host",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const Spacer(),

                // 🔹 Bottom buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left circle (people icon)
                    InkWell(
                      onTap: () {
                        _showFilterPopup(context);
                      },
                      child: CustomContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/three_circle.png", // 👈 apna image path yahan replace karo
                            height: 52,
                            width: 52,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right circle (refresh icon)
                    InkWell(
                      onTap: () {
                        callController
                            .switchCamera(); // 👈 flip front/back camera
                      },
                      child: CustomContainer(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                        conColor: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/refresh.png", // 👈 apna image path yahan replace karo
                            color: Colors.black,
                            height: 52,
                            width: 52,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Live Button
                CustomButton(
                  text: "Live",
                  backgroundColor: Colors.purple,
                  textColor: Colors.white,
                  height: 55,
                  width: size.width * 0.5,
                  onPressed: () async {
                    final data = await callController.startLiveCall(
                      AppUrl.token,
                    );
                    if (data != null && data["status"] == "success") {
                      final agora = data["agora"];
                      print(agora);
                      Get.to(
                        () => HostStartLiveStreamingScreen(),
                        arguments: {
                          "channelName": agora["channelName"],
                          "token": agora["token"],
                          "appId": agora["appId"],
                          "uid": agora["uid"],
                          "isHost": true,
                        },
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        data?["message"] ?? "Failed to start live",
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
