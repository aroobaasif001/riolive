import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'level_controller.dart';
import 'rich_level_screen.dart';
import 'wealth_level_screen.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/customcirclebutton.dart';

class LevelMainScreen extends StatelessWidget {
  final int initialPage;

  const LevelMainScreen({super.key, this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelNavigationController());

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
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Row (Back button only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CustomCircleButton(
                    size: 40,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Tabs
            LevelNavigation(controller: controller),

            const SizedBox(height: 12),

            // PageView Content
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                },
                children: const [RichLevelContent(), WealthLevelContent()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
