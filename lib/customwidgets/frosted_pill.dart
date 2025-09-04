import 'package:flutter/material.dart';

import 'custom_container.dart';

class FrostedPill extends StatelessWidget {
  final double? width;
  final double? height;
  final color;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const FrostedPill({
    required this.child,
    this.height,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      height: height,
      padding: padding,
      conColor: color,
      borderRadius: BorderRadius.circular(100),
      // gradient: LinearGradient(
      //   colors: [
      //     Colors.white.withOpacity(0.20),
      //     Colors.white.withOpacity(0.08),
      //   ],
      //   begin: Alignment.topLeft,
      //   end: Alignment.bottomRight,
      // ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 25,
          offset: const Offset(0, 3),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.12),
          blurRadius: 25,
          offset: const Offset(-2, -2),
        ),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.8),
      child: child,
    );
  }
}
