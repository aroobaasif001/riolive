import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_end_screen/party_room_end_screen.dart';

import '../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../customwidgets/chat_list.dart';
import '../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/hostCircle.dart';
import '../../../../../../customwidgets/join_button.dart';
import '../../../../../../customwidgets/message_field.dart';
import '../../../../../../customwidgets/partyRoomUserToolSheet.dart';
import '../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../customwidgets/round_icon.dart';
import '../../../../../../customwidgets/seatCircle.dart';
import '../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../customwidgets/showWaitingListSheet.dart';
import '../../../../../../customwidgets/tiny_round.dart';
import '../../../../../../customwidgets/userVideoCallShowRoomToolSheet.dart';
import '../../../../../../models/live_card_data.dart';

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
                                children: [
                                  const TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_1.jpg',
                                    ),
                                  ),
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
                                  const SizedBox(width: 4),
                                  CloseButton(
                                    color: Colors.white,
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red,
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(
                                        () => LiveEndScreen(
                                          bgImage:
                                              'assets/images/userTabImage.jpg',
                                          userName: 'Wamiqa J..',
                                          avatarPath:
                                              'assets/images/story_1.jpg',
                                          crownPath: 'assets/icons/crown_2.png',
                                          cards: const [
                                            LiveCardData(
                                              image:
                                                  'assets/images/story_1.jpg',
                                              name: 'Himanshi Khurana 🥰',
                                            ),
                                            LiveCardData(
                                              image:
                                                  'assets/images/story_1.jpg',
                                              name: 'Kaanch 🥰',
                                            ),
                                            LiveCardData(
                                              image:
                                                  'assets/images/story_1.jpg',
                                              name: 'Himanshi Khurana 🥰',
                                              isGray: true,
                                            ),
                                            LiveCardData(
                                              image:
                                                  'assets/images/story_1.jpg',
                                              name: 'Kaanch 🥰',
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HostCircle(
                              name: 'Wamiqa Jain',
                              image: 'assets/images/story_1.jpg',
                              highlight: true,
                              isHost: true,
                            ),
                            Image.asset(
                              'assets/images/match.png',
                              width: 72,
                              height: 52,
                            ),
                            const HostCircle(
                              name: 'Wamiqa Jain',
                              image: 'assets/images/story_2.png',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SeatCircle(
                            onTap: () {
                              showPartyRoomUserToolSheet(context);
                            },
                            label: 'Meet Bros',
                            state: SeatState.occupied,
                            image: 'assets/images/story_1.jpg',
                            frameImage: "assets/images/frame_3.png",
                          ),
                          const SeatCircle(
                            label: 'Anushka',
                            state: SeatState.occupied,
                            image: 'assets/images/story_2.png',
                            frameImage: "assets/images/frame_3.png",
                          ),
                          SeatCircle(
                            label: 'Seat No:-3',
                            state: SeatState.empty,
                            frameImage: "",
                            onTap: () {
                              showWaitingListSheet(context);
                            },
                          ),
                          const SeatCircle(
                            label: 'Seat No:-4',
                            state: SeatState.empty,
                            frameImage: "",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
