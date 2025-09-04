import 'package:flutter/material.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';
import 'customtext.dart';

void showGamesSheet(BuildContext context) {
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
                    "Games",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  SizedBox(height: 10),
                  Row(
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
                  SizedBox(height: 10),
                  Padding(
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
