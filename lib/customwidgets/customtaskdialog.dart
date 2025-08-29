import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../views/bottom_navi_screens/screens/agency_screens/agency_screen.dart';
import '../views/bottom_navi_screens/screens/profile_screen/customer_service/customer_service_screen.dart';
import '../views/bottom_navi_screens/screens/profile_screen/settings_screen/settings_screen.dart';
import '../views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/bind_screen.dart';
import '../views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/face_auth_screen.dart';
import 'custom_container.dart';

class TaskDialog extends StatelessWidget {
  final String imagePath = 'assets/images/daytaskimage.png'; // dialog bg image

  const TaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        children: [
          // ---- Blur behind dialog ----
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: CustomContainer(conColor: Colors.black.withOpacity(0)),
            ),
          ),

          // ---- Dialog content ----
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Heading: only here we keep shadow
              CustomText(
                "Day 2 task",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                shadows: const [
                  Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black54),
                ],
              ),

              // Background image container
              CustomContainer(
                height: 487,
                width: 350,
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
                child: Stack(
                  children: [
                    // ================= TOP SHOP CAPSULE (4 items) =================
                    Positioned(
                      top: 130,
                      left: 10,
                      right: 10,
                      child: CustomContainer(
                        height: 81,
                        width: 320,
                        image: const DecorationImage(image: AssetImage('assets/images/Union.png')),
                        borderRadius: BorderRadius.circular(20),
                        padding: const EdgeInsets.only(left: 10, top: 12),
                        child: Row(
                          children: [
                            // item 1
                            Column(
                              children: [
                                CustomContainer(
                                  height: 48,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)],
                                  ),
                                  child: Image.asset('assets/images/1.png', fit: BoxFit.contain),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 74,
                                  child: CustomText(
                                    'Decor - Star Trek',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white.withOpacity(.95),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.2,
                                    shadows: const [], // remove shadow
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 7),

                            // item 2
                            Column(
                              children: [
                                CustomContainer(
                                  height: 48,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)],
                                  ),
                                  child: Image.asset('assets/images/2.png', fit: BoxFit.contain),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 72,
                                  child: CustomText(
                                    'Bike Fire',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white.withOpacity(.95),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.2,
                                    shadows: const [], // remove shadow
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 7),

                            // item 3
                            Column(
                              children: [
                                CustomContainer(
                                  height: 48,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)],
                                  ),
                                  child: Image.asset('assets/images/car.png', fit: BoxFit.contain),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 72,
                                  child: CustomText(
                                    'Ferrari car',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white.withOpacity(.95),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.2,
                                    shadows: const [], // remove shadow
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 7),

                            // item 4
                            Column(
                              children: [
                                CustomContainer(
                                  height: 48,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)],
                                  ),
                                  child: Image.asset('assets/images/last.png', fit: BoxFit.contain),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 72,
                                  child: CustomText(
                                    'Goddess Crown',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white.withOpacity(.95),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    lineHeight: 1.2,
                                    shadows: const [], // remove shadow
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ================= REQUIRE + NOTE =================
                    Positioned(
                      top: 60,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              CustomText(
                                'Require',
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                shadows: [], // remove shadow
                              ),
                              SizedBox(width: 6),
                              Image(
                                image: AssetImage('assets/icons/diamond_icon 2 1.png'),
                                height: 17,
                                width: 17,
                              ),
                              SizedBox(width: 6),
                              CustomText(
                                'x50',
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                shadows: [], // remove shadow
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Image(
                                image: AssetImage('assets/icons/About_24.png'),
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(width: 4),
                              CustomText(
                                'Need to be completed in 3 days',
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                shadows: [], // remove shadow
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ================= SCROLLABLE CARDS (ListView.builder) =================
                    Positioned(
                      top: 230,
                      left: 20,
                      right: 20,
                      bottom: 10,
                      child: Builder(
                        builder: (context) {
                          final items = [
                            {
                              'title': 'Voice match 0/1',
                              'subtitle': 'Complete 1 voice matches for more\n than 1 minutes',
                              'reward': 'x5'
                            },
                            {
                              'title': 'Friend interaction 0/1',
                              'subtitle': 'Send 5 messages to each other\n with friends',
                              'reward': 'x50'
                            },
                            {
                              'title': 'To attend a party 0/1',
                              'subtitle': 'Speak for more than1 minutes in\n the party room',
                              'reward': 'x100'
                            },
                          ];

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final it = items[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == items.length - 1 ? 0 : 8,
                                ),
                                child: CustomContainer(
                                  height: 74,
                                  width: 320,
                                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                                  conColor: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.12),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  child: Row(
                                    children: [
                                      // left text block
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              it['title']!,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF1A1A1A),
                                              shadows: const [], // remove shadow
                                            ),
                                            const SizedBox(height: 4),
                                            CustomText(
                                              it['subtitle']!,
                                              fontSize: 10,
                                              lineHeight: 1.2,
                                              color: const Color(0xFF8A8A8F),
                                              fontWeight: FontWeight.w500,
                                              shadows: const [], // remove shadow
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // right reward + Go
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomContainer(
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/diamond_icon 2 1.png',
                                                  width: 16,
                                                  height: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                CustomText(
                                                  it['reward']!,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  shadows: const [], // remove shadow
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            width: 53,
                                            height: 25,
                                            alignment: Alignment.center,
                                            borderRadius: BorderRadius.circular(24),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0xFFB06BFF), Color(0xFF7A53FF)],
                                            ),
                                            child: const CustomText(
                                              'Go',
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              shadows: [], // remove shadow
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Image.asset('assets/icons/crossicon.png', height: 19, width: 19),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          // ✅ Moved here: Positioned must be a direct child of Stack

        ],
      ),
    );
  }
}

class Back {}

void showTaskDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const TaskDialog(),
  );
}
