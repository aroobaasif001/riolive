import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/utile/app_url.dart';

import '../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../customwidgets/chat_list.dart';
import '../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/hostCircle.dart';
import '../../../../../../customwidgets/join_button.dart';
import '../../../../../../customwidgets/message_field.dart';
import '../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../customwidgets/round_icon.dart';
import '../../../../../../customwidgets/seatCircle.dart';
import '../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../customwidgets/tiny_round.dart';
import '../../../../../../customwidgets/userVideoCallShowRoomToolSheet.dart';

class PartyRoomScreen extends GetView<UserVideoCallController> {
  const PartyRoomScreen({super.key});

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

                /* ----------------- MID CONTENT ----------------- */
                Expanded(
                  child: Column(
                    children: [
                      // Hosts row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const HostCircle(
                              name: 'Wamiqa Jain',
                              image: 'assets/images/story_1.jpg',
                              highlight: true,
                              isHost: true,
                            ),
                            Image.asset(
                              'assets/images/match.png', // 👈 yahan apna path dal do
                              width: 162,
                              height: 52,
                              // color: Colors
                              //     .pinkAccent, // optional agar color overlay chahiye
                            ),
                            const HostCircle(
                              name: 'Wamiqa Jain',
                              image: 'assets/images/story_2.png',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Seats row 1 (3,4)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          SeatCircle(
                            label: 'Meet Bros',
                            state: SeatState.occupied,
                            image: 'assets/images/story_1.jpg',
                            frameImage: "assets/images/frame_3.png",
                          ),
                          SeatCircle(
                            label: 'Anushka',
                            state: SeatState.occupied,
                            image: 'assets/images/story_2.png',
                            frameImage: "assets/images/frame_3.png",
                          ),
                          SeatCircle(
                            label: 'Seat No:-3',
                            state: SeatState.empty,
                            frameImage: "",
                          ),
                          SeatCircle(
                            label: 'Seat No:-4',
                            state: SeatState.empty,
                            frameImage: "",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Seats row 2 (5..8)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          SeatCircle(
                            label: 'Seat No:-5',
                            state: SeatState.empty,
                            frameImage: "",
                          ),
                          SeatCircle(
                            label: 'Seat No:-6',
                            state: SeatState.locked,
                            frameImage: "",
                          ),
                          SeatCircle(
                            label: 'Seat No:-7',
                            state: SeatState.locked,
                            frameImage: "",
                          ),
                          SeatCircle(
                            label: 'Seat No:-8',
                            state: SeatState.locked,
                            frameImage: "",
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Right side overlay (entered/join)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: const [JoinButton()],
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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

enum SeatState { occupied, empty, locked }
