import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/round_glow.dart';
import 'package:riolive/customwidgets/tiny_round.dart';

import '../controller/user_video_call_controller.dart';
import 'customtext.dart';
import 'frosted_pill.dart';

class ProfileChip extends GetView<UserVideoCallController> {
  const ProfileChip();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FrostedPill(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TinyRound(
              size: 36,
              image: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  controller.hostName.value,
                  fontType: AppFont.poppins,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                CustomText(
                  'ID: ${controller.hostId.value}',
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.85),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const RoundGlow(
              color: Colors.pinkAccent,
              size: 28,
              child: Icon(
                Icons.person_add_alt_1,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
