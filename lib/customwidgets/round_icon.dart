import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/round_glow.dart';

import 'custom_container.dart';

class RoundIcon extends StatelessWidget {
  final ImageProvider image;
  const RoundIcon({required this.image});

  @override
  Widget build(BuildContext context) {
    return RoundGlow(
      color: Colors.white.withOpacity(0.4),
      size: 52,
      child: CustomContainer(
        height: 52,
        width: 52,
        // shape: BoxShape.circle,
        image: DecorationImage(image: image, fit: BoxFit.fitWidth),
      ),
    );
  }
}
