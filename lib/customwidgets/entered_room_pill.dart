import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/tiny_round.dart';

import 'customtext.dart';
import 'gradient_pill.dart';

class EnteredRoomPill extends StatelessWidget {
  final String username;
  const EnteredRoomPill({required this.username});

  @override
  Widget build(BuildContext context) {
    return GradientPill(
      height: 36,
      gradient: const LinearGradient(
        colors: [Color(0xffFFB444), Color(0xffFF6A88)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TinyRound(
            size: 24,
            image: AssetImage('assets/images/story_1.jpg'),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: CustomText(
              '$username : entered the room',
              color: Colors.white,
              fontSize: 12.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
