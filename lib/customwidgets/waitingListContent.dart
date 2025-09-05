import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/titleTab.dart';
import 'package:riolive/customwidgets/waitingTile.dart';

import '../utile/const.dart';
import 'circleIcon.dart';
import 'custom_container.dart';
import 'customtext.dart';
import 'effectMsgSettingSheet.dart';
import 'filledGradientButton.dart';
import 'gradientOutlineButton.dart';
import 'guestLiveEmpty.dart';

class WaitingListContent extends StatefulWidget {
  const WaitingListContent({required this.controller});
  final ScrollController controller;

  @override
  State<WaitingListContent> createState() => _WaitingListContentState();
}

class _WaitingListContentState extends State<WaitingListContent> {
  int _activeTab = 0; // 0=Waiting, 1=Guest Live, 2=Recommend

  Future<void> _openSettings(BuildContext context) async {
    // Close this sheet, then open the settings sheet
    Get.back(); // 👈 as requested
    await Future.delayed(const Duration(milliseconds: 150));
    showEffectMsgSettingSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // absorb taps
      child: CustomContainer(
        conColor: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        child: Column(
          children: [
            // drag handle
            Center(
              child: CustomContainer(
                width: 54,
                height: 5,
                conColor: handleColor.withOpacity(.9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),

            // Title row (tabs + right action)
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      TitleTab(
                        text: 'Waiting',
                        active: _activeTab == 0,
                        onTap: () => setState(() => _activeTab = 0),
                      ),
                      const SizedBox(width: 10),
                      TitleTab(
                        text: 'Guest Live',
                        active: _activeTab == 1,
                        onTap: () => setState(() => _activeTab = 1),
                      ),
                      const SizedBox(width: 10),
                      TitleTab(
                        text: 'Recommend',
                        active: _activeTab == 2,
                        onTap: () => setState(() => _activeTab = 2),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (_activeTab == 1) {
                          await _openSettings(context); // 👈 open the new popup
                        } else {
                          // optional: show help
                        }
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          _activeTab == 1 ? Icons.settings : Icons.help_outline,
                          color: Colors.grey,
                          size: 27,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleIcon(
                      icon: Icons.close,
                      bg: const Color(0xFFED5B5B),
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Subheading per tab
            Row(
              children: [
                Icon(
                  _activeTab == 0
                      ? Icons.back_hand_outlined
                      : _activeTab == 1
                      ? Icons.chair_outlined
                      : Icons.star_border_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                CustomText(
                  _activeTab == 0
                      ? 'Waiting List (3)'
                      : _activeTab == 1
                      ? 'Guest Live'
                      : 'Recommend',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Dynamic body
            Expanded(
              child: Builder(
                builder: (_) {
                  if (_activeTab == 1) {
                    return GuestLiveEmpty();
                  } else if (_activeTab == 2) {
                    return Center(
                      child: Text(
                        'No recommendations yet',
                        style: const TextStyle(
                          color: mutedText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return ListView.separated(
                      controller: widget.controller,
                      itemCount: 3,
                      separatorBuilder: (_, __) => Divider(
                        color: divider.withOpacity(.35),
                        height: 16,
                        thickness: 1,
                      ),
                      itemBuilder: (_, i) => WaitingTile(
                        avatar: 'assets/images/story_1.jpg',
                        name: 'Ava😅Nueva❤️😘',
                        genderText: '\u2640', // ♀
                        ageText: '20',
                        levelText: 'Lv60',
                        onTap: () {},
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            // Bottom action buttons
            Row(
              children: [
                Expanded(
                  child: GradientOutlineButton(
                    gradientColors: audioOutlineGrad,
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/micro_phone.png',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 8),
                        const CustomText(
                          'Audio Join',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: FilledGradientButton(
                    gradientColors: videoFillGrad,
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/video_camera.png',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 8),
                        const CustomText(
                          'Video Join',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
