import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wealth_level_screen.dart';

class RichLevelScreen extends StatelessWidget {
  const RichLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070628), // Solid background color
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Row (Back button only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Top Row Tabs (Rich level | Wealth level)
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Rich level",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const WealthLevelScreen());
                      },
                      child: Text(
                        "Wealth level",
                        style: TextStyle(fontSize: 20, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Card with user info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                  const SizedBox(height: 8),
                  const Text(
                    "Wamiqa Jain",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.white24,
                    color: Colors.orange,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Current Exp",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Text(
                    "The distance to upgrade: 1/3000",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Info Boxes
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _infoCard(
                      title: "What are Rich levels?",
                      description:
                          "User level: According to the number of gifts send & get Exp. 1 Diamond = 1 Experience Value.",
                    ),
                    _infoCard(
                      title: "How to improve your wealth level?",
                      description:
                          "Rih level is determined by experience values, lucky gifts 10 diamond = 1 Experience value; luxury gifts 1 diamond = 1 Experience value.",
                    ),

                    const SizedBox(height: 12),

                    // Grid of Levels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(10, (index) {
                          final levels = [1, 6, 11, 21, 31, 41, 51, 61, 71, 81];
                          return _levelCard("LV. ${levels[index]}");
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _levelCard(String level) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          level,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
