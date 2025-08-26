import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ranking_controller.dart';
import 'charm_screen.dart';
import 'wealth_screen.dart';
import 'family_screen.dart';

class RankingMainScreen extends StatelessWidget {
  final int initialPage;

  const RankingMainScreen({super.key, this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RankingNavigationController());

    // Set initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != initialPage) {
        controller.currentIndex.value = initialPage;
        controller.pageController.animateToPage(
          initialPage,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF070628),
      body: Stack(
        children: [
          // PageView Content (Full Screen)
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentIndex.value = index;
            },
            children: const [
              CharmRankingContent(),
              WealthRankingContent(),
              FamilyRankingContent(),
            ],
          ),

          // Overlay UI Elements
          Column(
            children: [
              // Status bar spacing
              SizedBox(height: MediaQuery.of(context).padding.top),

              // App Bar Row (Back button only)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Navigation Tabs with Header (Centered on top of image)
              RankingNavigation(controller: controller),
            ],
          ),
        ],
      ),
    );
  }
}
