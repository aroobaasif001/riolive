import 'package:flutter/material.dart';
import 'ranking_main_screen.dart';

class CharmRankingScreen extends StatelessWidget {
  const CharmRankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RankingMainScreen(initialPage: 0);
  }
}

class CharmRankingContent extends StatelessWidget {
  const CharmRankingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background Image
        Positioned.fill(
          child: Image.asset("assets/images/ranking1.png", fit: BoxFit.cover),
        ),

        /// Foreground UI
        Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd Place
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/avatar2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Alex Media",
                        style: TextStyle(
                          color: Color(0xFFFEA917),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "15000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                  // 1st Place
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/avatar1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Winner",
                        style: TextStyle(
                          color: Color(0xFFFEA917),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "25000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                  // 3rd Place
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/avatar3.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Savon DIlva",
                        style: TextStyle(
                          color: Color(0xFFFEA917),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "12000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),

            /// Pink Section (List)
            Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFF43E7F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF00A7C1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/avatar.png",
                              ),
                              radius: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              index == 5
                                  ? "Me Myself"
                                  : "Charming Beauty${index + 4}🔥",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          index == 5 ? "8.5k" : "${10 - index}.2k",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
