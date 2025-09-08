import 'package:flutter/material.dart' hide Chip;
import 'package:riolive/customwidgets/custom_container.dart';

import 'Chip.dart';
import 'chipGenderAge.dart';
import 'customtext.dart';

class WaitingTile extends StatelessWidget {
  const WaitingTile({
    required this.avatar,
    required this.name,
    required this.genderText,
    required this.ageText,
    required this.levelText,
    this.onTap,
  });

  final String avatar;
  final String name;
  final String genderText;
  final String ageText;
  final String levelText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomContainer(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    avatar,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: CustomContainer(
                  width: 22,
                  height: 22,
                  gradient: LinearGradient(
                    colors: [Color(0xFF8FE68D), Color(0xFF23AF64)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: const Icon(
                    Icons.signal_cellular_alt,
                    size: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  name,
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChipGenderAge(gender: genderText, age: ageText),
                    const SizedBox(width: 8),
                    Chip(text: levelText),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
