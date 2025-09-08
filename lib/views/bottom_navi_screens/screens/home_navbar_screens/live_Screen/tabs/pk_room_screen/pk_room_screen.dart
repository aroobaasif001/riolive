import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_end_screen/party_room_end_screen.dart';

import '../../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../../customwidgets/chat_list.dart';
import '../../../../../../../customwidgets/coins_chip.dart';
import '../../../../../../../customwidgets/custom_container.dart';
import '../../../../../../../customwidgets/customtext.dart';
import '../../../../../../../customwidgets/hostCircle.dart';
import '../../../../../../../customwidgets/join_button.dart';
import '../../../../../../../customwidgets/message_field.dart';
import '../../../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../../../customwidgets/profile_chip.dart';
import '../../../../../../../customwidgets/round_icon.dart';
import '../../../../../../../customwidgets/showGamesSheet.dart';
import '../../../../../../../customwidgets/showGiftPopUp.dart';
import '../../../../../../../customwidgets/showProfilePopup.dart';
import '../../../../../../../customwidgets/show_pk_details_popup.dart';
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
                                InkWell(
                                  onTap: () {
                                    showPkDetailPopUp(context);
                                  },
                                  child: CoinsChip(
                                    "100.10",
                                    Colors.white.withOpacity(0.2),
                                    true,
                                  ),
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
                              left: 115,
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
                                  SizedBox(height: 30),
                                  Image.asset(
                                    "assets/icons/pk_2.png",
                                    height: 150,
                                    width: 150,
                                  ),
                                ],
                              ),
                            ),
                            // Progress bar below PK Timer
                            Positioned(
                              bottom: 270,
                              child: GestureDetector(
                                onTap: () {
                                  showPkDetailsPopup(context);
                                },
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

void showPkDetailPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.back(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) {
              // Dummy data
              final contributors = [
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_1.jpg",
                  "frame": "assets/images/frame_2.png",
                  "score": "50",
                  "badges": [
                    "assets/icons/vip_1.png",
                    "assets/icons/top_1.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "Hayda✨🎀",
                  "image": "assets/images/story_2.png",
                  "frame": "assets/images/frame_2.png",
                  "score": "541",
                  "badges": [
                    "assets/icons/vip_2.png",
                    "assets/icons/top_1.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_3.jpg",
                  "frame": "assets/images/frame_2.png",
                  "score": "5550",
                  "badges": [
                    "assets/icons/vip_3.png",
                    "assets/icons/top2.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_1.jpg",
                  "frame": "assets/images/frame_2.png",
                  "score": "825",
                  "badges": [
                    "assets/icons/vip_5.png",
                    "assets/icons/top3.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_2.png",
                  "frame": "assets/images/frame_2.png",
                  "score": "550",
                  "badges": [
                    "assets/icons/vip_1.png",
                    "assets/icons/top3.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_3.jpg",
                  "frame": "assets/images/frame_2.png",
                  "score": "50",
                  "badges": ["assets/icons/vip_2.png", "assets/icons/max.png"],
                  "isLast": true,
                },
              ];

              final rankColors = [
                const Color(0xFFFFD700), // Gold
                const Color(0xFFC0C0C0), // Silver
                const Color(0xFFCD7F32), // Bronze
                const Color(0xFF3E2723), // Dark Brown
              ];

              return CustomContainer(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF000000), Color(0xFF10172C)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Column(
                  children: [
                    // ===== Top Header =====
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: CustomText(
                        "PK Details",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // ===== Winner Section =====
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            HostCircle(
                              name: "👑 ZO 🦋",
                              image: "assets/images/story_2.png",
                              height: 120.0,
                              width: 120.0,
                              frame: "assets/icons/win_frame.png",
                              isHost: true,
                              isSquare: true,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ===== Contribution List =====
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: contributors.length,
                        itemBuilder: (context, index) {
                          final user = contributors[index];
                          final bgColor = index < 3
                              ? rankColors[index]
                              : rankColors.last;
                          final isLast = user["isLast"] == true;
                          final badges = user["badges"] as List<String>;

                          return CustomContainer(
                            conColor: bgColor.withOpacity(0.12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                // Rank number
                                CustomText(
                                  isLast ? "20+" : "${index + 1}",
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(width: 12),

                                // Avatar with frame
                                HostCircle(
                                  frame: user['frame'].toString(),
                                  height: 40.0,
                                  width: 40.0,
                                  name: "",
                                  image: user["image"].toString(),
                                  isHost: true,
                                ),
                                const SizedBox(width: 10),

                                // Name + badges
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        user["name"].toString(),
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: badges
                                            .map(
                                              (b) => Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                child: Image.asset(
                                                  b,
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Coins score
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/coin.png", // 👈 change asset if diamond needed
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      user["score"].toString(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
