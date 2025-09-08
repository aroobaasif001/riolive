import 'package:flutter/material.dart';

import 'custom_container.dart';

class AvatarWithCrown extends StatelessWidget {
  const AvatarWithCrown({required this.avatar, required this.crown});
  final String avatar;
  final String crown;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        CustomContainer(
          width: 86,
          height: 86,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.amberAccent, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],

          child: ClipOval(child: Image.asset(avatar, fit: BoxFit.cover)),
        ),
        Positioned(
          top: -12, // thoda upar
          left: 156, // thoda left
          child: Transform.rotate(
            angle: 0.15, // thoda tilt (in radians) ~ -17 degrees
            child: Image.asset(crown, height: 30, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
