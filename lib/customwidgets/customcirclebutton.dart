import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as fb;

class CustomCircleButton extends StatelessWidget {
  final Widget child; // Icon / Image
  final double size;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomCircleButton({
    super.key,
    required this.child,
    this.size = 80,
    this.backgroundColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size,
        width: size,
        decoration: fb.BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            // Outer shadows
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.40),
              blurRadius: 2,
              offset: const Offset(0, 5),
            ),
            fb.BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(30, 20),
            ),
            // Inner highlights (inset shadows)
            const fb.BoxShadow(
              color: Colors.white,
              blurRadius: 10,
              offset: Offset(-5, -5),
              inset: true,
            ),
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 10,
              offset: const Offset(1, 5),
              inset: true,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
