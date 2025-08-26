import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'tabs/follow_tab.dart';
import 'tabs/square_tab.dart';
import 'tabs/video_tab.dart';
import 'search_screen.dart';

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
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [_floatingButtons()]),
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
                            ? CustomContainer(
                                // Gradient border
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xffFFD964), Color(0xff6FFFA9)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x3383C69F), blurRadius: 6, offset: Offset(0, 2)),
                                ],
                                padding: const EdgeInsets.all(1.6),
                                child: CustomContainer(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  borderRadius: BorderRadius.circular(28),
                                  conColor: selectedButtonIndex == 1 ? Colors.transparent : const Color(0xFFFFFFFF),
                                  child: Center(
                                    child: CustomText(
                                      text: buttonNames[index],
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
                                    text: buttonNames[index],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
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

  // ==== Floating Buttons ====
  Widget _floatingButtons() {
    Widget ringButton(
      IconData icon, {
      double outer = 56,
      double inner = 44,
      Color outerColor = const Color(0xFFEDEDED),
      Color iconColor = const Color(0xFF2E7CF6),
    }) {
      return Container(
        height: outer,
        width: outer,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: outerColor,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Center(
          child: Container(
            height: inner,
            width: inner,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: inner * 0.55),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ringButton(Icons.play_arrow_rounded, outer: 56, inner: 40, iconColor: const Color(0xFF29A2FF)),
            const SizedBox(width: 12),
            ringButton(Icons.photo_camera_rounded, outer: 56, inner: 40, iconColor: const Color(0xFFFFB74D)),
          ],
        ),
        const SizedBox(height: 8),
        ringButton(Icons.blur_circular_rounded, outer: 72, inner: 56, iconColor: const Color(0xFF29A2FF)),
      ],
    );
  }
}
