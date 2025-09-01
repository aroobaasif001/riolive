import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party_room_controller.dart';
import 'customtext.dart';
import 'frosted_pill.dart';

class CoinsChip extends GetView<PartyRoomController> {
  const CoinsChip();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FrostedPill(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on,
              size: 18,
              color: Color(0xffFFC86B),
            ),
            const SizedBox(width: 6),
            CustomText(
              '${(controller.coin.value / 1000).toStringAsFixed(2)} k',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}
