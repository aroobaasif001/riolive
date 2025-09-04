import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as fb;
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final borderRadius;
  final gradientColors;
  final color;
  final onTap;


  const CustomButton({
    super.key,
    required this.text,
    this.textColor = const Color(0xff9055FA),
    this.height,
    this.width,
    this.backgroundColor = Colors.white,
    required this.onPressed,
    this.borderRadius,
    this.gradientColors,
    this.color,
    this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? screenWidth * 0.15, // Default ~14% of width
        width: width ?? screenWidth * 0.8, // Default 80% of width
        decoration: fb.BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            // Outer Shadow
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.40),
              blurRadius: 7,
              offset: const Offset(1, 5),
            ),
            // Inner highlight (top-left)
            const fb.BoxShadow(
              color: Colors.white,
              blurRadius: 6,
              offset: Offset(4, 4),
              inset: true,
            ),
            // Inner shadow (bottom-right)
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.55),
              blurRadius: 6,
              offset: const Offset(4, 4),
              inset: true,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
