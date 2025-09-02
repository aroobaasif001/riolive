import 'package:flutter/material.dart';

import 'customtext.dart';
import 'gradient_pill.dart';

class LevelTag extends StatelessWidget {
  final int level;
  const LevelTag({required this.level});

  @override
  Widget build(BuildContext context) {
    return GradientPill(
      width: 70,
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gradient: const LinearGradient(
        colors: [Color(0xff28C0FF), Color(0xff6EE7F9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.badge_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          CustomText(
            'LV ${level}',
            fontSize: 11.5,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
