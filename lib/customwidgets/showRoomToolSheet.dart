import 'package:flutter/material.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';
import 'customtext.dart';
import '../utile/app_url.dart';

void showRoomToolsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return CustomContainer(
              conColor: const Color(0xff2D2A2A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 40,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CustomText(
                    "Room Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/share_3.png',
                        label: 'Share',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/flip_camera.png',
                        label: 'Flip Camera',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/sticker.png',
                        label: 'Sticker',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/micro_phone.png',
                        label: 'Micro',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                    "Other Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  _buildOtherToolsRow(),
                  const SizedBox(height: 10),
                  const CustomText(
                    "Games",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/talk_guess.png',
                        label: 'Talk Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/draw_guess.png',
                        label: 'Draw Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/digit_bomb.png',
                        label: 'Digit-Bomb',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/to_be_honest.png',
                        label: 'To Be Honest',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 19.0),
                    child: Row(
                      children: [
                        BottomIcon(
                          asset: 'assets/icons/clap_at_7.png',
                          label: 'Clap at 7',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

/// Build other tools row - conditionally show Private Call based on user role
Widget _buildOtherToolsRow() {
  List<Widget> tools = [
    const BottomIcon(
      asset: 'assets/icons/three_circle.png',
      label: 'Filter',
    ),
    const BottomIcon(
      asset: 'assets/icons/live_time.png',
      label: 'Live Time',
    ),
  ];

  // Only show Private Call button for non-host users
  // Hosts should not see this button as they can't call themselves
  if (AppUrl.user_role != 'host') {
    tools.add(
      const BottomIcon(
        asset: 'assets/icons/private_call.png',
        label: 'Private Call',
        // Note: This shouldn't be functional here as this sheet is for hosts
        // But keeping it for consistency if role detection is wrong
      ),
    );
  }

  tools.add(
    const BottomIcon(
      asset: 'assets/icons/admin.png',
      label: 'Admin',
    ),
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: tools,
  );
}
