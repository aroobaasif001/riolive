import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/utile/route_observer.dart';

import '../../../../controller/host_video_call_controller.dart';
import '../../../../controller/random_call_controller.dart';
import '../../../../customwidgets/custom_container.dart';
import '../../../../customwidgets/custombutton.dart';
import '../../../../customwidgets/customtext.dart';

// import '../../../../services/socket_service.dart';
import '../../../../customwidgets/filter_bottom_sheet.dart';
import 'host_start_live_streaming_screen/host_start_live_streaming_screen.dart';

class HostVideoCallScreen extends StatefulWidget {
  const HostVideoCallScreen({super.key});

  @override
  State<HostVideoCallScreen> createState() => _HostVideoCallScreenState();
}

class _HostVideoCallScreenState extends State<HostVideoCallScreen>
    with WidgetsBindingObserver, RouteAware {
  final callController = Get.put(CallController());
  bool _initializedOnce = false;
  bool _isAutoRefreshing = false;

  final controller = Get.put(HostVideoCallController());
  final size = Get.size;

  @override
  void initState() {
    print("init");
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAgoraPreview();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is PageRoute) {
      appRouteObserver.subscribe(this, route);
    }
    // Also handle becoming current again via Flutter route lifecycle
    final route2 = ModalRoute.of(context);
    if (route2?.isCurrent == true && _initializedOnce && !_isAutoRefreshing) {
      Future.microtask(() async {
        _isAutoRefreshing = true;
        await _forceReinitializePreview();
        _isAutoRefreshing = false;
      });
    }
  }

  // (single dispose already defined earlier)

  // Called when a higher route is popped and we become visible again
  @override
  void didPopNext() {
    // Small delay to let the transition finish
    Future.delayed(
      const Duration(milliseconds: 150),
      _forceReinitializePreview,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Recreate preview when coming back to the foreground
      _initAgoraPreview();
    }
  }

  Future<void> _initAgoraPreview() async {
    // Ensure any previous session is fully cleaned up
    try {
      await callController.engine?.stopPreview();
    } catch (_) {}

    await callController.leaveChannel();

    try {
      await callController.engine?.release();
    } catch (_) {}
    callController.engine = null;

    // Small delay to allow native resources to be released properly
    await Future.delayed(const Duration(milliseconds: 300));

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

      // Set proper profile and role for preview reliability on some devices
      await callController.engine!.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await callController.engine!.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
      );

      // Small delay to avoid race after initialize
      await Future.delayed(const Duration(milliseconds: 120));

      await callController.engine!.enableVideo();
      await callController.engine!.enableLocalVideo(true);

      // Try starting preview with retries (handles device driver delays)
      await _startPreviewWithRetry(callController.engine!, retries: 3);
      setState(() {
        _initializedOnce = true;
      });
    } catch (e) {
      debugPrint("Agora preview init error: $e");
    }
  }

  Future<void> _forceReinitializePreview() async {
    try {
      try {
        await callController.engine?.stopPreview();
      } catch (_) {}
      await callController.leaveChannel();
      try {
        await callController.engine?.release();
      } catch (_) {}
      callController.engine = null;
      await Future.delayed(const Duration(milliseconds: 300));
      await _initAgoraPreview();
      // Get.snackbar(
      //   "Camera",
      //   "Preview refreshed",
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
    } catch (e) {
      debugPrint("Force reinit error: $e");
      // Get.snackbar(
      //   "Camera",
      //   "Failed to refresh preview",
      //   backgroundColor: Colors.red.withOpacity(0.8),
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> _startPreviewWithRetry(
    RtcEngine engine, {
    int retries = 2,
  }) async {
    int attempts = 0;
    while (true) {
      try {
        await engine.startPreview();
        return;
      } catch (e) {
        attempts++;
        if (attempts > retries) {
          rethrow;
        }
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance.removeObserver(this);
    appRouteObserver.unsubscribe(this);
    try {
      callController.engine?.stopPreview();
    } catch (_) {}
    callController.leaveChannel();
    super.dispose();
  }

  // Old inline filter popup removed; unified FilterBottomSheet is used instead

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔹 Agora Local Preview
          if (callController.engine != null)
            KeyedSubtree(
              key: ValueKey(callController.engine),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: callController.engine!,
                  canvas: const VideoCanvas(
                    uid: 0,
                    sourceType:
                        VideoSourceType.videoSourceCamera, // 👈 important
                  ),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          SafeArea(
            child: Column(
              children: [
                // Close button ❌
                InkWell(
                  onTap: () async {
                    await callController.engine?.stopPreview();
                    await callController.leaveChannel();
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                      // SizedBox(
                        // child: CloseButton(
                        //
                        //   style: ButtonStyle(
                        //     backgroundColor: WidgetStatePropertyAll(Colors.red),
                        //     // iconSize: ,
                        //   ),
                        //   onPressed: () async {
                        //     // 👇 stop preview & release engine
                        //     await callController.engine?.stopPreview();
                        //     await callController.leaveChannel();
                        //     Get.back();
                        //   },
                        //   color: Colors.white,
                        // ),
                      // ),
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
                                                : "assets/icons/group.png",
                                            // 🔒
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
                    // Left circle (filters) - unified bottom sheet
                    InkWell(
                      onTap: () {
                        // Use the same filter UI used in live screen
                        FilterBottomSheet.show(context);
                      },
                      child: CustomContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/icons/three_circle.png",
                            height: 52,
                            width: 52,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Middle circle (flip camera)
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
                            "assets/icons/refresh.png", // icon used for flip
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
                InkWell(
                  onTap: () async {
                    debugPrint(
                      "🔴 LIVE BUTTON PRESSED - Starting live call...",
                    );

                    // ✅ Show loading while preparing live stream
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.black87,
                        content: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.purple),
                            SizedBox(width: 16),
                            Text(
                              'Preparing live stream...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      barrierDismissible: false,
                    );

                    try {
                      // ✅ Properly cleanup current engine before going live
                      debugPrint(
                        "🔴 Cleaning up preview engine before live...",
                      );
                      try {
                        await callController.engine?.stopPreview();
                        await Future.delayed(const Duration(milliseconds: 100));
                        await callController.leaveChannel();
                        await Future.delayed(const Duration(milliseconds: 100));
                        await callController.engine?.release();
                        callController.engine = null;
                      } catch (e) {
                        debugPrint("🔴 Cleanup warning: $e");
                      }

                      // ✅ Wait for cleanup to complete
                      await Future.delayed(const Duration(milliseconds: 300));

                      final data = await callController.startLiveCall(
                        AppUrl.token,
                      );
                      debugPrint(
                        "🔴 LIVE BUTTON - startLiveCall response: $data",
                      );

                      if (data != null && data["status"] == "success") {
                        final agora = data["agora"];
                        debugPrint("🔴 LIVE BUTTON - Agora data: $agora");
                        debugPrint(
                          "✅ LIVE BUTTON - Host registered successfully, navigating to live screen...",
                        );

                        // ✅ Close loading dialog
                        Get.back();

                        final result = await Get.to(
                              () => const HostStartLiveStreamingScreen(),
                          arguments: {
                            "channelName": agora["channelName"],
                            "token": agora["hostToken"] ?? agora["token"],
                            "appId": agora["appId"],
                            "uid": agora["uid"],
                            "isHost": true,
                          },
                        );

                        // When user ends live, reinitialize local preview here
                        if (result == 'ended' || result == true) {
                          debugPrint(
                            "⚫ LIVE ENDED - Reinitializing preview...",
                          );
                          // Slight delay to ensure previous screen is fully popped
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );
                          await _initAgoraPreview();
                        }
                      } else {
                        // ✅ Close loading dialog on error
                        Get.back();
                        debugPrint(
                          "❌ LIVE BUTTON - Failed to start live: $data",
                        );
                        Get.snackbar(
                          "Error",
                          data?["message"] ?? "Failed to start live",
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      // ✅ Close loading dialog on exception
                      if (Get.isDialogOpen == true) Get.back();
                      debugPrint("❌ LIVE BUTTON - Exception: $e");
                      Get.snackbar(
                        "Error",
                        "Failed to start live stream: $e",
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Container(
                    height: 55,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [Color(0xff996CE9), Color(0xffF858CB)],
                      ),
                    ),
                    child: Center(child: CustomText("Live",color: Colors.white,fontSize: 22,fontWeight: FontWeight.w900,)),
                  ),
                ),

                // CustomButton(
                //   text: "Live",
                //   backgroundColor: Colors.purple,
                //   textColor: Colors.white,
                //   height: 55,
                //   gradientColors: [Color(0xff996CE9), Color(0xffF858CB)],
                //   width: size.width * 0.5,
                //   onPressed: () async {
                //     debugPrint(
                //       "🔴 LIVE BUTTON PRESSED - Starting live call...",
                //     );
                //
                //     // ✅ Show loading while preparing live stream
                //     Get.dialog(
                //       AlertDialog(
                //         backgroundColor: Colors.black87,
                //         content: const Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             CircularProgressIndicator(color: Colors.purple),
                //             SizedBox(width: 16),
                //             Text(
                //               'Preparing live stream...',
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           ],
                //         ),
                //       ),
                //       barrierDismissible: false,
                //     );
                //
                //     try {
                //       // ✅ Properly cleanup current engine before going live
                //       debugPrint(
                //         "🔴 Cleaning up preview engine before live...",
                //       );
                //       try {
                //         await callController.engine?.stopPreview();
                //         await Future.delayed(const Duration(milliseconds: 100));
                //         await callController.leaveChannel();
                //         await Future.delayed(const Duration(milliseconds: 100));
                //         await callController.engine?.release();
                //         callController.engine = null;
                //       } catch (e) {
                //         debugPrint("🔴 Cleanup warning: $e");
                //       }
                //
                //       // ✅ Wait for cleanup to complete
                //       await Future.delayed(const Duration(milliseconds: 300));
                //
                //       final data = await callController.startLiveCall(
                //         AppUrl.token,
                //       );
                //       debugPrint(
                //         "🔴 LIVE BUTTON - startLiveCall response: $data",
                //       );
                //
                //       if (data != null && data["status"] == "success") {
                //         final agora = data["agora"];
                //         debugPrint("🔴 LIVE BUTTON - Agora data: $agora");
                //         debugPrint(
                //           "✅ LIVE BUTTON - Host registered successfully, navigating to live screen...",
                //         );
                //
                //         // ✅ Close loading dialog
                //         Get.back();
                //
                //         final result = await Get.to(
                //           () => const HostStartLiveStreamingScreen(),
                //           arguments: {
                //             "channelName": agora["channelName"],
                //             "token": agora["hostToken"] ?? agora["token"],
                //             "appId": agora["appId"],
                //             "uid": agora["uid"],
                //             "isHost": true,
                //           },
                //         );
                //
                //         // When user ends live, reinitialize local preview here
                //         if (result == 'ended' || result == true) {
                //           debugPrint(
                //             "⚫ LIVE ENDED - Reinitializing preview...",
                //           );
                //           // Slight delay to ensure previous screen is fully popped
                //           await Future.delayed(
                //             const Duration(milliseconds: 500),
                //           );
                //           await _initAgoraPreview();
                //         }
                //       } else {
                //         // ✅ Close loading dialog on error
                //         Get.back();
                //         debugPrint(
                //           "❌ LIVE BUTTON - Failed to start live: $data",
                //         );
                //         Get.snackbar(
                //           "Error",
                //           data?["message"] ?? "Failed to start live",
                //           backgroundColor: Colors.red.withOpacity(0.8),
                //           colorText: Colors.white,
                //         );
                //       }
                //     } catch (e) {
                //       // ✅ Close loading dialog on exception
                //       if (Get.isDialogOpen == true) Get.back();
                //       debugPrint("❌ LIVE BUTTON - Exception: $e");
                //       Get.snackbar(
                //         "Error",
                //         "Failed to start live stream: $e",
                //         backgroundColor: Colors.red.withOpacity(0.8),
                //         colorText: Colors.white,
                //       );
                //     }
                //   },
                // ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      // FAB also added; if not visible due to layout, use the in-screen button above
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: _forceReinitializePreview,
      //   backgroundColor: Colors.blueGrey,
      //   child: const Icon(Icons.refresh, color: Colors.white),
      // ),
    );
  }
}
