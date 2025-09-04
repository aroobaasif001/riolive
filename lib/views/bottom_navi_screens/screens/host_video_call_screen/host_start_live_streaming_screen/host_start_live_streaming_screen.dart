import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../controller/random_call_controller.dart';
import '../../../../../controller/user_video_call_controller.dart';
import '../../../../../customwidgets/coins_chip.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/message_field.dart';
import '../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../customwidgets/profile_chip.dart';
import '../../../../../customwidgets/round_icon.dart';
import '../../../../../customwidgets/showRoomToolSheet.dart';
import '../../../../../customwidgets/tiny_round.dart';
import '../../../../../services/socket_service.dart';
import '../../../../../utile/app_url.dart';
import '../../home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';

class HostStartLiveStreamingScreen extends StatefulWidget {
  const HostStartLiveStreamingScreen({super.key});

  @override
  State<HostStartLiveStreamingScreen> createState() =>
      _HostStartLiveStreamingScreenState();
}

class _HostStartLiveStreamingScreenState
    extends State<HostStartLiveStreamingScreen> {
  final callController = Get.put(CallController());
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAgora();
      _attachIncomingCallListeners();
    });
  }

  void _attachIncomingCallListeners() {
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);

    SocketService.to.socket?.on('incoming_call', _onIncomingCall);
    SocketService.to.socket?.on('call_started', _onIncomingCall);
  }

  void _onIncomingCall(dynamic raw) async {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final callerName = (data['callerName'] ?? data['userName'] ?? 'Unknown')
          .toString();

      if (callId.isEmpty) return;

      if (Get.isDialogOpen == true) Get.back();

      Get.dialog(
        AlertDialog(
          title: const Text("📞 Incoming Call"),
          content: Text("$callerName is calling you."),
          actions: [
            TextButton(
              onPressed: () {
                SocketService.to.socket?.emit("call_rejected", {
                  "callId": callId,
                  "userId": AppUrl.riolive_id,
                  "timestamp": DateTime.now().millisecondsSinceEpoch,
                });
                Get.back();
              },
              child: const Text("Reject", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                try {
                  final c = Get.find<CallController>();
                  final joinResp = await c.joinCall(AppUrl.token, callId);
                  if (joinResp == null) {
                    Get.snackbar("Error", "Failed to join call");
                    return;
                  }

                  final channelName =
                      (joinResp['agora']?['channelName'] ??
                              joinResp['call']?['room_id'] ??
                              data['channelName'] ??
                              data['channel'] ??
                              data['roomId'] ??
                              '')
                          .toString();

                  final token =
                      (joinResp['agora']?['hostToken'] ??
                              joinResp['agora']?['token'] ??
                              joinResp['token'] ??
                              data['agora']?['token'] ??
                              data['token'] ??
                              '')
                          .toString();

                  if (channelName.isEmpty || token.isEmpty) {
                    Get.snackbar("Error", "Invalid call data received");
                    return;
                  }

                  SocketService.to.socket?.emit("call_accepted", {
                    "callId": callId,
                    "userId": AppUrl.riolive_id,
                    "userName": AppUrl.user_name,
                    "channelName": channelName,
                    "timestamp": DateTime.now().millisecondsSinceEpoch,
                  });

                  Get.to(
                    () => VideoCallScreen(
                      token: AppUrl.token,
                      callId: callId,
                      channelName: channelName,
                      agoraToken: token,
                      isHost:
                          false, // host yahan live tha, ye call accept as user
                    ),
                  );
                } catch (e) {
                  Get.snackbar("Error", "Failed to accept call: $e");
                }
              },
              child: const Text(
                "Accept",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint("host live incoming_call parse error: $e");
    }
  }

  void _initializeAgora() async {
    if (_isInitialized) return;

    /// get the args passed from previous screen
    final args = Get.arguments as Map<String, dynamic>;

    debugPrint("Initializing Agora with args: $args");

    /// join agora channel
    await callController.initAgora(
      channelName: args["channelName"],
      agoraToken: args["token"],
      appId: args["appId"],
      isHost: args["isHost"] ?? false,
      isAudience: !(args["isHost"] ?? false),
      callId: args["channelName"], // can also use roomId
    );

    _isInitialized = true;
  }

  @override
  void dispose() {
    // cleanup listeners
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);

    callController.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(UserVideoCallController());

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Agora Video
          Obx(() {
            if (callController.hasError.value) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        callController.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          final args = Get.arguments as Map<String, dynamic>;
                          callController.initAgora(
                            channelName: args["channelName"],
                            agoraToken: args["token"],
                            appId: args["appId"],
                            isHost: args["isHost"] ?? false,
                            isAudience: !(args["isHost"] ?? false),
                            callId: args["channelName"],
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (callController.isJoined.value) {
              if (callController.remoteUid.value != null) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: callController.engine!,
                    canvas: VideoCanvas(uid: callController.remoteUid.value),
                    connection: RtcConnection(
                      channelId: callController.channel ?? "",
                    ),
                  ),
                );
              } else {
                return AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: callController.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                );
              }
            } else {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        "Connecting to live stream...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),

          /// 🔹 UI Overlay - Only show if joined successfully
          Obx(
            () => callController.isJoined.value
                ? SafeArea(
                    child: Stack(
                      children: [
                        /// ========= Profile + Top Bar =========
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Left: Profile info
                              ProfileChip(
                                false,
                                Colors.white.withOpacity(0.2),
                                "${AppUrl.user_name}",
                                "${AppUrl.riolive_id}",
                              ),

                              /// Right: Story circles + close button
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  const TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const PlusCountChip(countText: '+98'),
                                  const SizedBox(width: 8),

                                  /// Close button
                                  CloseButton(
                                    color: Colors.white,
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final response = await http.post(
                                        Uri.parse(AppUrl.offLiveLiveCall),
                                        headers: {
                                          'Authorization':
                                              "Bearer ${AppUrl.token}",
                                        },
                                      );
                                      debugPrint(response.body);
                                      final args =
                                          Get.arguments as Map<String, dynamic>;
                                      if (args["isHost"] == true) {
                                        await callController.endCall(
                                          AppUrl.token,
                                          args["channelName"],
                                        );
                                      }
                                      await callController.leaveChannel();
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// ========= Reward Popup =========
                        Positioned(
                          top: 70,
                          left: size.width * 0.02,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CoinsChip(
                                    "50",
                                    Colors.greenAccent.withOpacity(0.5),
                                    true,
                                  ),
                                  const SizedBox(width: 5),
                                  CoinsChip(
                                    "00 / 00 / 00",
                                    Colors.purple.withOpacity(0.5),
                                    false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              /// Popup Box
                              CustomContainer(
                                width: size.width * 0.75,
                                borderRadius: BorderRadius.circular(15),
                                conColor: Colors.white.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Level Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomContainer(
                                          conColor: Colors.lightBlue
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CustomText(
                                              "💎 Level 1",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        CustomContainer(
                                          conColor: Colors.purple.withOpacity(
                                            0.4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CustomText(
                                              "0/60 Min",
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        CustomContainer(
                                          conColor: Colors.greenAccent
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  size: 16,
                                                  color: Color(0xffFFC86B),
                                                ),
                                                SizedBox(width: 4),
                                                CustomText(
                                                  "1000/H",
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    /// Progress Bar
                                    CustomContainer(
                                      height: 14,
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.deepOrangeAccent,
                                        ],
                                      ),
                                      width:
                                          (size.width * 0.7) *
                                          0.0, // progress value
                                    ),
                                    const SizedBox(height: 8),

                                    CustomContainer(
                                      width: double.infinity,
                                      conColor: Colors.greenAccent.withOpacity(
                                        0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.monetization_on,
                                                size: 16,
                                                color: Color(0xffFFC86B),
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                "0",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              SizedBox(width: 6),
                                              CustomText(
                                                "/",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              SizedBox(width: 6),
                                              Icon(
                                                Icons.monetization_on,
                                                size: 16,
                                                color: Color(0xffFFC86B),
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                "100000",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ========= Bottom Bar =========
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: [
                              const Expanded(child: MessageField()),
                              const SizedBox(width: 12),
                              const RoundIcon(
                                image: AssetImage('assets/icons/pk.png'),
                              ),
                              const SizedBox(width: 14),
                              InkWell(
                                onTap: () => showRoomToolsSheet(context),
                                child: const RoundIcon(
                                  image: AssetImage('assets/icons/apps.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
