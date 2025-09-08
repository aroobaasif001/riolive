import 'package:flutter/material.dart';

import '../utile/const.dart';
import 'customtext.dart';

class GuestLiveEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Expanded(
          child: Center(
            child: CustomText(
              'No guests, invite your friends and meet with them',
              color: mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              // height: 1.4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
