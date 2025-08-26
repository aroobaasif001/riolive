import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../customwidgets/customtext.dart';

class RankingNavigationController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final RxInt currentTimeFilter = 0.obs; // 0 = Daily, 1 = Weekly

  void switchToPage(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void switchTimeFilter(int filterIndex) {
    if (currentTimeFilter.value != filterIndex) {
      currentTimeFilter.value = filterIndex;
      // You can add additional logic here if needed
      // For example, refreshing data based on the selected time filter
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class RankingNavigation extends StatelessWidget {
  final RankingNavigationController controller;

  const RankingNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Ranking title and Last Month
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Stack(
            children: [
              // Centered Ranking title
              Center(
                child: CustomText(
                  "Ranking",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Right-aligned Last Month
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    CustomText("Last Month", fontSize: 14, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Navigation Tabs
        Obx(
          () => Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => controller.switchToPage(0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: controller.currentIndex.value == 0
                              ? ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFFD964),
                                          Color(0xFF6FFFA9),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  child: const CustomText(
                                    "Charm",
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const CustomText(
                                  "Charm",
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(
                            gradient: controller.currentIndex.value == 0
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD964),
                                      Color(0xFF6FFFA9),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: controller.currentIndex.value == 0
                                ? null
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => controller.switchToPage(1),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: controller.currentIndex.value == 1
                              ? ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFFD964),
                                          Color(0xFF6FFFA9),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  child: const CustomText(
                                    "Wealth",
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const CustomText(
                                  "Wealth",
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(
                            gradient: controller.currentIndex.value == 1
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD964),
                                      Color(0xFF6FFFA9),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: controller.currentIndex.value == 1
                                ? null
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => controller.switchToPage(2),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: controller.currentIndex.value == 2
                              ? ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFFFFD964),
                                          Color(0xFF6FFFA9),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds),
                                  child: const CustomText(
                                    "Family",
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const CustomText(
                                  "Family",
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(
                            gradient: controller.currentIndex.value == 2
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD964),
                                      Color(0xFF6FFFA9),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: controller.currentIndex.value == 2
                                ? null
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Daily / Weekly buttons with navigation
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => controller.switchTimeFilter(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: controller.currentTimeFilter.value == 0
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    "Daily",
                    fontSize: 16,
                    color: controller.currentTimeFilter.value == 0
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: controller.currentTimeFilter.value == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => controller.switchTimeFilter(1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: controller.currentTimeFilter.value == 1
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    "Weekly",
                    fontSize: 16,
                    color: controller.currentTimeFilter.value == 1
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: controller.currentTimeFilter.value == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
