import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/utile/app_url.dart';

import '../../../../../../controller/random_call_controller.dart'
    as random_call_controller;
import '../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../customwidgets/chat_list.dart';
import '../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../../../../../customwidgets/entered_room_pill.dart';
import '../../../../../../customwidgets/gift_strip.dart';
import '../../../../../../customwidgets/join_button.dart';
import '../../../../../../customwidgets/message_field.dart';
import '../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../customwidgets/round_icon.dart';
import '../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../customwidgets/tiny_round.dart';
import '../../../../../../customwidgets/userVideoCallShowRoomToolSheet.dart';
import '../../../../../../services/socket_service.dart';
import '../../call_screen/video_call_screen/video_call_screen.dart';

class UserVideoCallScreen extends StatefulWidget {
  const UserVideoCallScreen({super.key});

  @override
  State<UserVideoCallScreen> createState() => _UserVideoCallScreenState();
}

class _UserVideoCallScreenState extends State<UserVideoCallScreen> {
  late final UserVideoCallController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserVideoCallController());
    _attachIncomingCallListeners();
  }

  void _attachIncomingCallListeners() {
    // screen-local popup (zyada pretty control ke liye)
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);

    SocketService.to.socket?.on('incoming_call', _onIncomingCall);
    SocketService.to.socket?.on('call_started', _onIncomingCall);
  }

  void _onIncomingCall(dynamic raw) {
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
        _incomingCallSheet(callId, callerName, data),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint("user screen incoming_call parse error: $e");
    }
  }

  Widget _incomingCallSheet(
    String callId,
    String callerName,
    Map<String, dynamic> data,
  ) {
    return AlertDialog(
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
            // Accept flow -> SocketService ke through join + navigate
            // (yeh method token/channel resolve karke navigate karta hai)
            // public helper expose nahi hai, to hum minimal duplicate:
            try {
              final c = Get.find<random_call_controller.CallController>();
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
                  isHost: false,
                ),
              );
            } catch (e) {
              Get.snackbar("Error", "Failed to accept call: $e");
            }
          },
          child: const Text("Accept", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // screen-unmount par listeners cleanup
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomContainer(
        width: size.width,
        height: size.height,
        image: const DecorationImage(
          image: AssetImage('assets/images/userTabImage.jpg'),
          fit: BoxFit.cover,
        ),
        child: CustomContainer(
          conColor: Colors.black.withOpacity(0.1),
          child: SafeArea(
            child: Column(
              children: [
                /* -------------------- TOP BAR -------------------- */
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showProfilePopup(context);
                                },
                                child: ProfileChip(
                                  true,
                                  Colors.white.withOpacity(0.2),
                                  "${AppUrl.user_name}",
                                  "${AppUrl.riolive_id}",
                                ),
                              ),
                              const SizedBox(width: 2),
                              Row(
                                children: const [
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_1.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  PlusCountChip(countText: '+98'),
                                  SizedBox(width: 4),
                                  CloseButton(
                                    color: Colors.white,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          CustomContainer(
                            width: 360,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CoinsChip(
                                  "100.10",
                                  Colors.white.withOpacity(0.2),
                                  true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.asset(
                                    "assets/images/riolive.png",
                                    height: 54,
                                    width: 54,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                /* ----------------- MID CONTENT ----------------- */
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GiftStrip(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              EnteredRoomPill(username: 'Alex'),
                              SizedBox(height: 10),
                              JoinButton(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          maxLines: 6,
                          'Welcome to the party room. We\nmonitor every LIVE Party to keep the\ncommunity safe and healthy.\nBehaviors of bullies, harasses, or\nintimidates will be reported or\nbanned from use.',
                          color: Colors.white,
                          fontSize: 12.5,
                          lineHeight: 1.35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: ChatList(),
                        ),
                      ),
                    ],
                  ),
                ),

                /* ----------------- BOTTOM ACTIONS ---------------- */
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                  child: Row(
                    children: [
                      const Expanded(child: MessageField()),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          showGiftPopup(context);
                        },
                        child: const RoundIcon(
                          image: AssetImage('assets/icons/gift.png'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          showGamesSheet(context);
                        },
                        child: const RoundIcon(
                          image: AssetImage('assets/icons/gamepad.png'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          userVideoCallShowRoomToolsSheet(context);
                        },
                        child: const RoundIcon(
                          image: AssetImage('assets/icons/apps.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
