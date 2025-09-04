import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final List<Color> gradientColors;
  final textColor;
  final onTap;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

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
    this.textColor,
    this.onTap,
    this.begin,
    this.end,
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
        child: CustomContainer(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: begin??Alignment.topCenter,
            end: end??Alignment.bottomCenter,
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          alignment: Alignment.center,
          child: CustomText(
            text,
            color: Colors.white,
            fontWeight: fontWeight,
            fontSize: fontSize,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
