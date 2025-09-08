import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/join_button.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_end_screen/party_room_end_screen.dart';

import '../../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../../customwidgets/chat_list.dart';
import '../../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../../customwidgets/custom_container.dart';
import '../../../../../../../customwidgets/message_field.dart';
import '../../../../../../../customwidgets/participant_card.dart';
import '../../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../../customwidgets/round_icon.dart';
import '../../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../../customwidgets/tiny_round.dart';
import '../../../../../../../customwidgets/userVideoCallShowRoomToolSheet.dart';
import '../../../../../../../models/live_card_data.dart';

class MultiRoomScreen extends GetView<UserVideoCallController> {
  const MultiRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserVideoCallController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomContainer(
        width: size.width,
        height: size.height,
        image: const DecorationImage(
          image: AssetImage('assets/images/backgroundimage_2.png'),
          fit: BoxFit.cover,
        ),
        child: CustomContainer(
          conColor: Colors.black.withOpacity(0.1),
          child: SafeArea(
            child: Column(
              children: [
                // ===== Top Section =====
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
                                      backgroundColor: MaterialStatePropertyAll(
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

                // ===== Center Section (Party Room Layout) =====
                CustomContainer(
                  height: 400,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ---- Host (Big left, square) ----
                            Expanded(
                              flex:
                                  2, // 👈 height zyada hogi (jitna bada chaho, flex barhao)
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/images/story_1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: 8,
                                    child: CustomContainer(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const CustomText(
                                        "Host",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: CustomContainer(
                                      borderRadius: BorderRadius.circular(20),
                                      conColor: Colors.black.withOpacity(0.5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/coin.png",
                                              height: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            const CustomText(
                                              "2.3M",
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: CustomContainer(
                                      width: 240,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          CustomText(
                                            "Himanshi❤️🤩",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(Icons.mic, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ---- Right side participants (dynamic, no extra space) ----
                            Expanded(
                              flex: 1,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final cardHeight =
                                      constraints.maxHeight / 2; // exact half
                                  return Column(
                                    children: List.generate(2, (index) {
                                      return SizedBox(
                                        height: cardHeight,
                                        width: double.infinity,
                                        child: ParticipantCard(
                                          index: index + 2,
                                          name: "Himanshi❤️🤩",
                                          image: "assets/images/story_2.png",
                                          coins: ["300k", "252.5k"][index],
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),

                            // ---- Bottom row participants (dynamic adjustable, no space) ----
                          ],
                        ),
                      ),

                      // ---- Bottom row participants (dynamic adjustable) ----
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = 3;
                          final cardWidth =
                              constraints.maxWidth / crossAxisCount;
                          final cardHeight = cardWidth;

                          return Wrap(
                            spacing: 0,
                            runSpacing: 0,
                            children: List.generate(3, (index) {
                              return SizedBox(
                                width: cardWidth,
                                height: cardHeight,
                                child: ParticipantCard(
                                  index: index + 5,
                                  name: "Himanshi❤️🤩",
                                  image: "assets/images/story_3.jpg",
                                  coins: ["2k", "25k", "50k"][index],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ===== Bottom Section =====
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 4),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: JoinButton(),
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(height: size.height * 0.177, child: ChatList()),
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
                            const SizedBox(width: 12),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
