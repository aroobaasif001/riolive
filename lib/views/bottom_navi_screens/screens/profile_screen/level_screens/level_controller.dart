import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/custom_container.dart';

class LevelNavigationController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class LevelNavigation extends StatelessWidget {
  final LevelNavigationController controller;

  const LevelNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => controller.switchToPage(0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: controller.currentIndex.value == 0
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: CustomText(
                    "Rich level",
                    fontSize: 20,
                    color: controller.currentIndex.value == 0
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: controller.currentIndex.value == 0
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
                onTap: () => controller.switchToPage(1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: controller.currentIndex.value == 1
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: CustomText(
                    "Wealth level",
                    fontSize: 20,
                    color: controller.currentIndex.value == 1
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: controller.currentIndex.value == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
