import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
import '../../../../../../customwidgets/tiny_round.dart';

class UserVideoCallScreen extends GetView<UserVideoCallController> {
  const UserVideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserVideoCallController());
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
                          const Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.,
                            children: [
                              ProfileChip(),
                              SizedBox(width: 5),
                              Row(
                                children: const [
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_1.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  PlusCountChip(countText: '+98'),
                                  SizedBox(width: 6),
                                  CloseButton(),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          CustomContainer(
                            width: 360,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // 👈 dono ko max space par push karega
                              children: [
                                CoinsChip(), // left side
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.asset(
                                    "assets/images/riolive.png", // 👈 apni image ka path
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
                      // Gift + Join row
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GiftStrip(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
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

                      // Chat list scrollable
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      const Expanded(
                        // 👈 message field full width le sakta hai
                        child: MessageField(),
                      ),
                      const SizedBox(width: 12),
                      RoundIcon(image: AssetImage('assets/icons/gift.png')),
                      const SizedBox(width: 14),
                      RoundIcon(image: AssetImage('assets/icons/gamepad.png')),
                      const SizedBox(width: 14),
                      RoundIcon(image: AssetImage('assets/icons/apps.png')),
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
