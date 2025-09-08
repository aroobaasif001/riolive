import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_container.dart';
import 'customtext.dart';
import 'hostCircle.dart';

void showPkDetailsPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.back(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (_, controller) {
              // Demo contributors list
              final contributors = [
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_1.jpg",
                  "frame": "assets/images/frame_2.png",
                  "score": "50",
                  "badges": [
                    "assets/icons/vip_1.png",
                    "assets/icons/fire.png",
                    "assets/icons/top_1.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "Hayda✨🎀",
                  "image": "assets/images/story_2.png",
                  "frame": "assets/icons/frame_3.png",
                  "score": "541",
                  "badges": [
                    "assets/icons/vip_2.png",
                    "assets/icons/blue.png",
                    "assets/icons/top_1.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_3.jpg",
                  "frame": "assets/icons/frame_4.png",
                  "score": "5550",
                  "badges": [
                    "assets/icons/vip_3.png",
                    "assets/icons/rose.png",
                    "assets/icons/top2.png",
                    "assets/icons/max.png",
                  ],
                },
                {
                  "name": "ارحام💖🌸🎀☁️",
                  "image": "assets/images/story_1.jpg",
                  "frame": "assets/icons/frame_5.png",
                  "score": "50",
                  "badges": [
                    "assets/icons/vip_5.png",
                    "assets/icons/blue.png",
                    "assets/icons/top3.png",
                    "assets/icons/max.png",
                  ],
                  "isLast": true, // 👈 mark last row
                },
              ];

              // background colors per rank
              final rankColors = [
                const Color(0xFFFFD700), // gold
                const Color(0xFFC0C0C0), // silver
                const Color(0xFFCD7F32), // bronze
                const Color(0xFF3E2723), // dark brown
              ];

              return CustomContainer(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF000000), Color(0xFF10172C)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Column(
                  children: [
                    // ===== Header =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 15,
                        // vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF9C348B), Color(0xFFDE78F4)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 68.0,
                              bottom: 30,
                            ),
                            child: CustomText(
                              "PK Contribution List",
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/pk_seal.png", // 👈 replace with your pink PK badge
                            height: 55,
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 8),

                    // ===== Contribution List =====
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: contributors.length,
                        itemBuilder: (context, index) {
                          final user = contributors[index];
                          final bgColor = index < 3
                              ? rankColors[index]
                              : rankColors.last;
                          final badges = user["badges"] as List<String>;
                          final isLast = user["isLast"] == true;

                          return CustomContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            conColor: bgColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(0),
                            child: Row(
                              children: [
                                // Rank number or 20+
                                CustomText(
                                  isLast ? "20+" : "${index + 1}",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(width: 12),

                                // Avatar with frame
                                HostCircle(
                                  frame: user['frame'].toString(),
                                  height: 40.0,
                                  width: 40.0,
                                  name: "", // hide name inside HostCircle
                                  image: user["image"].toString(),
                                  isHost: true,
                                ),
                                const SizedBox(width: 10),

                                // Name + Badges below
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        user["name"].toString(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: badges
                                            .map(
                                              (b) => Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                child: Image.asset(
                                                  b,
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Diamonds score
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/diamond_icon 2 1.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      user["score"].toString(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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
              );
            },
          ),
        ),
      );
    },
  );
}
