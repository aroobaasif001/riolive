import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'custom_container.dart';


class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    this.onTap,
    this.height = 64,
    this.borderRadius = 32,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        height: height,
        width: double.infinity,
        borderRadius: BorderRadius.circular(borderRadius),
        conColor: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              hintText,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.grey.shade500,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: Colors.black.withOpacity(0.85),
            ),
          ],
        ),
      ),
    );
  }
}
