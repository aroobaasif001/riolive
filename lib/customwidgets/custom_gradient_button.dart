import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  // ✅ Customization options
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final List<Color> gradientColors;
  final Color textColor; // Added this to customize the text color
  final Alignment? begin ; // Added this to customize the text color
  final Alignment? end; // Added this to customize the text color

  const CustomGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 15,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.gradientColors = const [Color(0xFF8EC2FB), Color(0xFFE496FF)],
    this.textColor = Colors.white, this.begin,  this.end, // Default text color is white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Use the textColor parameter here
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
