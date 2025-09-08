import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_end_screen/party_room_end_screen.dart';

import '../../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../../customwidgets/chat_list.dart';
import '../../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../../customwidgets/custom_container.dart';
import '../../../../../../../customwidgets/customtext.dart';
import '../../../../../../../customwidgets/join_button.dart';
import '../../../../../../../customwidgets/message_field.dart';
import '../../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../../customwidgets/round_icon.dart';
import '../../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../../customwidgets/tiny_round.dart';
import '../../../../../../../customwidgets/userVideoCallShowRoomToolSheet.dart';
import '../../../../../../../models/live_card_data.dart';

class PkRoomScreen extends GetView<UserVideoCallController> {
  const PkRoomScreen({super.key});

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
                Expanded(
                  child: Stack(
                    children: [
                      // Centered PK Timer and Progress Bar
                      Positioned.fill(
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            // The images of the users (left and right)
                            Positioned(
                              left: 0,
                              child: Image.asset(
                                'assets/images/story_1.jpg',
                                width: 200,
                                height: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Image.asset(
                                'assets/images/story_2.png',
                                width: 200,
                                height: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // PK label and Timer at the top-center
                            Positioned(
                              left: 135,
                              child: Column(
                                children: [
                                  CustomContainer(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    ),
                                    conColor: Colors.black.withOpacity(0.4),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 5.0,
                                        left: 15,
                                        right: 15,
                                        bottom: 5,
                                      ),
                                      child: CustomText(
                                        "PK 03:02",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Progress bar below PK Timer
                            Positioned(
                              bottom: 270,
                              child: SizedBox(
                                height: 20,
                                width: size.width,
                                child: LinearProgressIndicator(
                                  value: 0.8,
                                  backgroundColor: Colors.blue,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            // Circular Avatars below progress bar
                            Positioned(
                              bottom: 230,
                              left: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_1.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_1.jpg',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chat list at the bottom
                      Positioned(
                        top: 320,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [JoinButton()],
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  size.height *
                                  0.265, // Adjust height as needed
                              child: ChatList(),
                            ),
                          ],
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
