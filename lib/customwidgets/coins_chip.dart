import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import '../controller/user_video_call_controller.dart';
import 'customtext.dart';
import 'frosted_pill.dart';

class CoinsChip extends GetView<UserVideoCallController> {
  var value;
  var color;
  var visible;
  CoinsChip(this.value, this.color, this.visible);

  @override
  Widget build(BuildContext context) {
    return FrostedPill(
      color: color,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          visible == true
              ? Icon(Icons.monetization_on, size: 18, color: Color(0xffFFC86B))
              : CustomContainer(),
          const SizedBox(width: 6),
          CustomText(
            '${value} ${visible == true ? 'k' : ''}',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
