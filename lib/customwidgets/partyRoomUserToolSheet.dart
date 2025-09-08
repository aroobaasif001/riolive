import 'package:flutter/material.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';

void showPartyRoomUserToolSheet(BuildContext context) {
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
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return CustomContainer(
              conColor: Colors.black,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/micro_phone.png',
                        label: 'Mute',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/admin.png',
                        icon: Icons.person,
                        label: 'Kick',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/admin.png',
                        icon: Icons.person_off_sharp,
                        label: 'Block',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/passwordicon.png',
                        icon: Icons.lock,
                        label: 'Smart Lock',
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
