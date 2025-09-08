import 'package:flutter/material.dart';

import '../utile/const.dart';
import 'custom_container.dart';

class GradientOutlineButton extends StatelessWidget {
  const GradientOutlineButton({
    required this.child,
    required this.onTap,
    required this.gradientColors,
  });

  final Widget child;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: CustomContainer(
        padding: const EdgeInsets.all(2),
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(28),

        child: CustomContainer(
          height: 52,
          alignment: Alignment.center,
          conColor: sheetBg, // inner same as panel to create outline effect
          borderRadius: BorderRadius.circular(28),

          child: child,
        ),
      ),
    );
  }
}
