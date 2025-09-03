import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/user_video_call_controller.dart';
import '../../../../../../customwidgets/buttom_icon.dart';
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
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showProfilePopup(context);
                                },
                                child: ProfileChip(
                                  true,
                                  Colors.white.withOpacity(0.2),
                                ),
                              ),
                              SizedBox(width: 2),
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
                      const Expanded(child: MessageField()),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          showGiftPopup(context);
                        },
                        child: RoundIcon(
                          image: AssetImage('assets/icons/gift.png'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          showGamesSheet(context);
                        },
                        child: RoundIcon(
                          image: AssetImage('assets/icons/gamepad.png'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          showRoomToolsSheet(context);
                        },
                        child: RoundIcon(
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
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

void showGamesSheet(BuildContext context) {
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

void showGiftPopup(BuildContext context) {
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
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Send to : Reya",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText(
                                "x1",
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: CustomText(
                                "Send",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Category tabs
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _categoryTab("Popular", true),
                        _categoryTab("Lucky", false),
                        _categoryTab("Events", false),
                        _categoryTab("Family", false),
                        _categoryTab("Cele", false),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Gift grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                        children: [
                          _giftItem(
                            "Goddess perfu..",
                            "50",
                            "assets/gifts/gift_1.png",
                          ),
                          _giftItem(
                            "Goddess Crown",
                            "50",
                            "assets/gifts/gift_2.png",
                          ),
                          _giftItem(
                            "Sapphire flowe..",
                            "100k",
                            "assets/gifts/gift_3.png",
                          ),
                          _giftItem(
                            "Golden Crystal..",
                            "50k",
                            "assets/gifts/gift_4.png",
                          ),
                          _giftItem(
                            "My Heart Will..",
                            "5M",
                            "assets/gifts/gift_5.png",
                          ),
                          _giftItem(
                            "Crystal diam..",
                            "1.5M",
                            "assets/gifts/gift_6.png",
                          ),
                          _giftItem(
                            "sapphire and d..",
                            "50",
                            "assets/gifts/gift_7.png",
                          ),
                          _giftItem(
                            "Advanced Trea..",
                            "50",
                            "assets/gifts/gift_8.png",
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.pink, size: 20),
                        SizedBox(width: 8),
                        CustomText(
                          "50 k",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.card_giftcard,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              CustomText(
                                "First Top-up Gifts",
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ],
                          ),
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

Widget _categoryTab(String categoryName, bool isSelected) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GestureDetector(
      onTap: () {
        // Handle category switch
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.3))
              : null,
        ),
        child: CustomText(
          categoryName,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget _giftItem(String name, String price, String imagePath) {
  return GestureDetector(
    onTap: () {
      // Handle gift selection
    },
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(height: 2),
          CustomText(
            name,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 8,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/diamond_icon 2 1.png',
                height: 10,
                width: 10,
              ),
              SizedBox(width: 2),
              CustomText(
                price,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 8,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showProfilePopup(BuildContext context) {
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
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE8B4F8),
                    Color(0xFFD8A7F8),
                    Color(0xFFC89AF8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Top icons row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 24),
                        Icon(
                          Icons.alternate_email,
                          color: Colors.black,
                          size: 24,
                        ),
                      ],
                    ),
                  ),

                  // Profile section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Profile picture
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 37,
                            backgroundImage: AssetImage(
                              'assets/images/profile_picture.jpg',
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Name and verification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Wamiqa Jain",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.verified, color: Colors.blue, size: 20),
                          ],
                        ),

                        SizedBox(height: 8),

                        // ID and location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText(
                                "ID : 7205322",
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 16,
                            ),
                            CustomText(
                              "India",
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.female, color: Colors.pink, size: 16),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Level and VIP badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText(
                                "LV 21",
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText(
                                "11",
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomText(
                                "VIP4",
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Medal Wall section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          "Medal Wall :",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 8),

                        _medalIcon('assets/icons/medal_1.png'),
                        SizedBox(width: 8),
                        _medalIcon('assets/icons/medal_2.png'),
                        SizedBox(width: 8),
                        _medalIcon('assets/icons/medal_3.png'),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Stats section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statColumn("0", "Followers"),
                        Container(width: 1, height: 30, color: Colors.grey),
                        _statColumn("0", "Following"),
                        Container(width: 1, height: 30, color: Colors.grey),
                        _statColumn("0", "Send"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            "Follow",
                            Colors.purple,
                            LinearGradient(
                              colors: [
                                Color(0xFF8A3FFC), // Purple
                                Color(0xFFD16BA5), // Pinkish purple
                                Color(0xFFFF6F61), // Coral pink
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        _roundActionButton('assets/icons/message.png'),
                        SizedBox(width: 12),
                        _roundActionButton('assets/icons/call.png'),
                        SizedBox(width: 12),
                        _roundActionButton('assets/icons/gift.png'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

// Helper function to create medal icons
Widget _medalIcon(String imagePath) {
  return Container(
    width: 40,
    height: 40,
    // decoration: BoxDecoration(
    // shape: BoxShape.circle,
    // border: Border.all(color: Colors.white, width: 2),
    // ),
    child: Image.asset(imagePath),
  );
}

// Helper function to create stat columns
Widget _statColumn(String value, String title) {
  return Column(
    children: [
      CustomText(
        value,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18,
      ),
      CustomText(
        title,
        fontWeight: FontWeight.normal,
        color: Colors.grey[600]!,
        fontSize: 12,
      ),
    ],
  );
}

// Helper function to create action buttons (Follow button)
Widget _actionButton(String label, Color color, Gradient gradient) {
  return GestureDetector(
    onTap: () {
      // Handle button action
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: CustomText(
          label,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}

// Helper function to create round action buttons
Widget _roundActionButton(String imagePath) {
  return GestureDetector(
    onTap: () {
      // Handle button action
    },
    child: Container(
      width: 50,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFB388F5), // Purple-ish background (matching)
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Outer shadow (bottom right)
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          // Outer highlight (top left)
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 30,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
