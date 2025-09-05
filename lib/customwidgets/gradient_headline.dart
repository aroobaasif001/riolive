import 'package:flutter/material.dart';

import 'customtext.dart';

class GradientHeadline extends StatelessWidget {
  const GradientHeadline(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final Shader shader = const LinearGradient(
      colors: [Color(0xFF9900FF), Color(0xFFFFA257)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(const Rect.fromLTWH(0, 0, 300, 60));

    return CustomText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        foreground: Paint()..shader = shader,
        letterSpacing: .5,
      ),
    );
  }
}
