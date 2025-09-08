import 'package:flutter/material.dart';

import 'custom_container.dart';

class FilledGradientButton extends StatelessWidget {
  const FilledGradientButton({
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
        height: 52,
        alignment: Alignment.center,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        child: child,
      ),
    );
  }
}
