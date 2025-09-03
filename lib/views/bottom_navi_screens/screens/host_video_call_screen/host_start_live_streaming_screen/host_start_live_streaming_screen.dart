import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../controller/random_call_controller.dart';
import '../../../../../controller/user_video_call_controller.dart';
import '../../../../../customwidgets/buttom_icon.dart';
import '../../../../../customwidgets/coins_chip.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/message_field.dart';
import '../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../customwidgets/profile_chip.dart';
import '../../../../../customwidgets/round_icon.dart';
import '../../../../../customwidgets/tiny_round.dart';
import '../../../../../utile/app_url.dart';

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
    });
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
              // Show error message
              return Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 64),
                      SizedBox(height: 16),
                      Text(
                        callController.errorMessage.value,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Retry initialization
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
                        child: Text("Retry"),
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
                // Show local preview when no remote user
                return AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: callController.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                );
              }
            } else {
              // Show loading/placeholder while connecting
              return Container(
                color: Colors.black,
                child: Center(
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
                              ProfileChip(false, Colors.white.withOpacity(0.2)),

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
                                      print(response.body);
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
                              RoundIcon(
                                image: const AssetImage('assets/icons/pk.png'),
                              ),
                              const SizedBox(width: 14),
                              InkWell(
                                onTap: () => showRoomToolsSheet(context),
                                child: RoundIcon(
                                  image: const AssetImage(
                                    'assets/icons/apps.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

void showRoomToolsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return CustomContainer(
              conColor: const Color(0xff2D2A2A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: const [
                  Center(
                    child: SizedBox(
                      width: 40,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  CustomText(
                    "Room Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/share_3.png',
                        label: 'Share',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/flip_camera.png',
                        label: 'Flip Camera',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/sticker.png',
                        label: 'Sticker',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/micro_phone.png',
                        label: 'Micro',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    "Other Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/three_circle.png',
                        label: 'Filter',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/live_time.png',
                        label: 'Live Time',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/private_call.png',
                        label: 'Private Call',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/admin.png',
                        label: 'Admin',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    "Games",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/talk_guess.png',
                        label: 'Talk Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/draw_guess.png',
                        label: 'Draw Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/digit_bomb.png',
                        label: 'Digit-Bomb',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/to_be_honest.png',
                        label: 'To Be Honest',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 19.0),
                    child: Row(
                      children: [
                        BottomIcon(
                          asset: 'assets/icons/clap_at_7.png',
                          label: 'Clap at 7',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
