import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as fb;
import 'package:google_fonts/google_fonts.dart';

class CustomGoogleButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final double? iconSize;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomGoogleButton({
    super.key,
    this.text = "Sign in with Google",
    this.iconPath = "assets/icons/google.png",
    this.iconSize,
    this.height,
    this.width,
    this.backgroundColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? screenWidth * 0.15, // default ~14% of width
        width: width ?? screenWidth * 0.8,    // default 90% of width
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
        decoration: fb.BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            // 🌟 Outer shadow
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
            // 🌟 Inner top-left highlight
            const fb.BoxShadow(
              color: Colors.white,
              blurRadius: 6,
              offset: Offset(3, 10),
              inset: true,
            ),
            // 🌟 Inner bottom-right shadow
            fb.BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 6,
              offset: const Offset(3, 3),
              inset: true,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Image.asset(
              iconPath,
              height: iconSize ?? screenWidth * 0.09,
              width: iconSize ?? screenWidth * 0.09,
            ),
            SizedBox(width: screenWidth * 0.03),

            // Text with Montserrat font
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.040,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
