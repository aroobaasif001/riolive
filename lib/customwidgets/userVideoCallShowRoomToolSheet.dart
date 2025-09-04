import 'package:flutter/material.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';
import 'customtext.dart';

void userVideoCallShowRoomToolsSheet(BuildContext context) {
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
                children: const [
                  Center(
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
                  SizedBox(height: 12),
                  CustomText(
                    "Room Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
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
                  SizedBox(height: 10),
                  CustomText(
                    "Other Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/three_circle.png',
                        label: 'Filter',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/live_time.png',
                        label: 'Live Time',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/private_call.png',
                        label: 'Private Call',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/admin.png',
                        label: 'Admin',
                      ),
                    ],
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
