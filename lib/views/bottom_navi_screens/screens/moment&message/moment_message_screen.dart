import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'search_screen.dart';
import 'tabs/follow_tab.dart';
import 'tabs/square_tab.dart';
import 'tabs/video_tab.dart';

class MomentMessageScreen extends StatefulWidget {
  const MomentMessageScreen({super.key});

  @override
  State<MomentMessageScreen> createState() => _MomentMessageScreenState();
}

class _MomentMessageScreenState extends State<MomentMessageScreen> {
  int selectedButtonIndex = 2; // Default: Square Tab
  final buttonNames = ['Follow', 'Video', 'Square'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      // FAB sirf Square tab pe dikhega
      floatingActionButton: selectedButtonIndex == 2
          ? Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: CustomContainer(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                          height: 40,
                          width: 40,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/icons/video.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        CustomContainer(
                          height: 38,
                          width: 38,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/icons/photo.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    CustomContainer(
                      height: 49,
                      width: 49,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('assets/icons/camera.png'), fit: BoxFit.fill),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          // ==== Body ====
          // Modified: Position the body to start from 50% of the screen height
          Positioned.fill(
            child: Builder(
              builder: (context) {
                if (selectedButtonIndex == 0) return const FollowTab();
                if (selectedButtonIndex == 1) return const VideoTab();
                return const SquareTab();
              },
            ),
          ),

          // ==== Top Tabs ====
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                ...List.generate(buttonNames.length, (index) {
                  final bool isSelected = selectedButtonIndex == index;
                  return Expanded(
                    // 👈 हर button equal space लेगा
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6), // spacing बराबर
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedButtonIndex = index;
                          });
                        },
                        child: isSelected
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: GradientBoxBorder(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xffFFD964), Color(0xff6FFFA9)],
                                    ),
                                    width: 1.6,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x3383C69F), blurRadius: 6, offset: Offset(0, 2)),
                                  ],
                                ),
                                child: CustomContainer(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  borderRadius: BorderRadius.circular(28),
                                  conColor: selectedButtonIndex == 1
                                      ? Colors.transparent
                                      : const Color(0xFFFFFFFF),
                                  child: Center(
                                    child: CustomText(
                                      buttonNames[index],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: selectedButtonIndex == 1 ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : CustomContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                borderRadius: BorderRadius.circular(30),
                                conColor: const Color(0x30000000),
                                child: Center(
                                  child: CustomText(
                                    buttonNames[index],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SearchScreen());
                  },
                  child: Image.asset('assets/icons/searchiconcolor.png', height: 22, width: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
