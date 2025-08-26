import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rich_level_screen.dart';
import 'wealth_level_screen.dart';

class LevelNavigation extends StatelessWidget {
  final String currentLevel;

  const LevelNavigation({super.key, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (currentLevel != 'rich') {
                  Get.off(() => const RichLevelScreen());
                }
              },
              child: Text(
                "Rich level",
                style: TextStyle(
                  fontSize: 20,
                  color: currentLevel == 'rich' ? Colors.white : Colors.white70,
                  fontWeight: currentLevel == 'rich'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (currentLevel != 'wealth') {
                  Get.off(() => const WealthLevelScreen());
                }
              },
              child: Text(
                "Wealth level",
                style: TextStyle(
                  fontSize: 20,
                  color: currentLevel == 'wealth'
                      ? Colors.white
                      : Colors.white70,
                  fontWeight: currentLevel == 'wealth'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
