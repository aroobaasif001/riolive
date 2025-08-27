import 'package:flutter/material.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/custom_progress_indicator.dart';
import 'level_main_screen.dart';

class WealthLevelScreen extends StatelessWidget {
  const WealthLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelMainScreen(initialPage: 1);
  }
}

class WealthLevelContent extends StatelessWidget {
  const WealthLevelContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Card with user info
          CustomContainer(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            conColor: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1),
            image: const DecorationImage(
              image: AssetImage('assets/images/yellow_mesh.png'),
              fit: BoxFit.cover,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/crown.png', width: 60, height: 60),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      "Wamiqa Jain",
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/levels/lvl7.png',
                      width: 45,
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "LV.1",
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      "75%",
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.white24,
                  progressColor: Colors.white,
                  height: 6,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Current Exp",
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    CustomText(
                      "The distance to upgrade: 1/3000",
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Info Boxes
          _infoCard(
            title: "What are Host levels?",
            description:
            "Host level: According to the number of gifts and coins you get , 1 Coin = 1 Experience Value",
          ),

          const SizedBox(height: 12),

          // Grid of Wealth Levels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: List.generate(10, (index) {
                final levels = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
                return _wealthLevelCard(levels[index]);
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String description,
    IconData? icon,
  }) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            CustomContainer(
              padding: const EdgeInsets.all(10),
              conColor: const Color(0xFFFF6F61).withOpacity(0.15),
              shape: BoxShape.circle,
              child: Icon(icon, size: 22, color: const Color(0xFFFF6F61)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                const SizedBox(height: 24),
                CustomText(
                  description,
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                  lineHeight: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wealthLevelCard(int level) {
    return CustomContainer(
      width: 80,
      height: 100,
      gradient: const LinearGradient(
        colors: [
          Color(0xFF7B78CC), // top
          Color(0xFFC19EF5), // middle
          Color(0xFF18173D), // bottom
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      child: Center(
        child: Image.asset(
          'assets/levels/lvl$level.png', // 👈 your new level icons
          width: 55,
          height: 55,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
