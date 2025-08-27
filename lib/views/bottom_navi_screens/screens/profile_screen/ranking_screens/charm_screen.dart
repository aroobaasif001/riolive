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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/icons/coin.png",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "15000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/icons/coin.png",
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "25000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/icons/coin.png",
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "12000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        // Deep outer shadow for elevation
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                        // Ambient shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                        // Inner shadow effect (top-left light)
                        BoxShadow(
                          color: Color(0xFF43E7F6).withOpacity(0.3),
                          spreadRadius: -2,
                          blurRadius: 8,
                          offset: Offset(-2, -2),
                        ),
                        // Inner shadow effect (bottom-right dark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: -2,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00A7C1).withOpacity(0.9),
                          Color(0xFF008FA3).withOpacity(0.95),
                          Color(0xFF007A8A),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/frame.png",
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              index == 5 ? "Me" : "Jenny Wilson${index + 4}🔥",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/icons/coin.png",
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              index == 5 ? "8.5k" : "${10 - index}.2k",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
