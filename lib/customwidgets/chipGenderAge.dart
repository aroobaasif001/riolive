import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utile/const.dart';

class ChipGenderAge extends StatelessWidget {
  const ChipGenderAge({required this.gender, required this.age});
  final String gender;
  final String age;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: -math.pi / 4, // 315°
            child: Text(
              gender,
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            age,
            style: const TextStyle(
              color: chipText,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
