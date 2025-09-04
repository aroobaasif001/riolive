import 'package:flutter/material.dart';

import 'custom_container.dart';

class RoundGlow extends StatelessWidget {
  final double size;
  final Widget child;
  final color;
  const RoundGlow({required this.size, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size,
      width: size,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 0, spreadRadius: 0)],
      child: Center(child: child),
    );
  }
}
