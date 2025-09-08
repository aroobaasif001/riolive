import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/views/bottom_navi_screens/bottom_navi_screen.dart';

import '../../../../../../../customwidgets/avatar_with_crown.dart';
import '../../../../../../../customwidgets/close_fab.dart';
import '../../../../../../../customwidgets/live_end_panel.dart';
import '../../../../../../../models/live_card_data.dart';

class LiveEndScreen extends StatelessWidget {
  const LiveEndScreen({
    super.key,
    required this.bgImage,
    required this.userName,
    required this.avatarPath,
    required this.crownPath,
    required this.cards,
  });

  final String bgImage;
  final String userName;
  final String avatarPath;
  final String crownPath;
  final List<LiveCardData> cards;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              bgImage,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),
          Positioned(
            right: 16,
            top: 22 + MediaQuery.of(context).padding.top,
            child: CloseFab(onTap: () => Get.to(() => BottomNaviScreen())),
          ),
          Positioned(
            top: 14 + MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: AvatarWithCrown(avatar: avatarPath, crown: crownPath),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LiveEndPanel(
              height: size.height * .90,
              userName: userName,
              avatar: avatarPath,
              cards: cards,
            ),
          ),
        ],
      ),
    );
  }
}
