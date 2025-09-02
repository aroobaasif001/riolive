import 'package:flutter/material.dart';

import 'custom_container.dart';

class GradientPill extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Gradient gradient;
  final Widget child;
  final double? width;

  const GradientPill({
    required this.child,
    this.width,
    required this.gradient,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      height: height,
      padding: padding,
      borderRadius: BorderRadius.circular(42),
      gradient: gradient,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}
