import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as fb;
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? prefix; // 👈 ab ye Icon ya Image dono ho sakta hai
  final Widget? suffix; // 👈 same suffix bhi widget
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool showDivider;
  final double height; // Custom height
  final double width;  // Custom width
  final EdgeInsetsGeometry padding; // Custom padding
  final Color hintTextColor; // Custom hintText color
  final Color textColor; // Custom text color
  final hint;
  final maxLines;
  final maxLength;
  final readOnly;
  final suffixIcon;
  final Color? backgroundColor;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefix,
    this.suffix,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.showDivider = true,
    this.height = 50.0, // Default height
    this.width = 300.0, // Default width
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0), // Default padding
    this.hintTextColor = Colors.black38,
    this.textColor = Colors.black87, // Default text color
    this.hint,
    this.maxLines,
    this.maxLength,
    this.readOnly,
    this.suffixIcon,
    this.backgroundColor, // Default background color
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height, // Use custom height
      width: width, // Use custom width
      padding: padding, // Use custom padding
      decoration: fb.BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          fb.BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
          const fb.BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: Offset(3, 10),
            inset: true,
          ),
          fb.BoxShadow(
            color: Colors.black.withOpacity(0.50),
            blurRadius: 6,
            offset: const Offset(3, 3),
            inset: true,
          ),
        ],
      ),
      child: Row(
        children: [
          // 👈 Prefix (Icon ya Image dono)
          if (prefix != null) ...[prefix!],

          // 👈 Divider (only if prefix exists + showDivider = true)
          if (prefix != null && showDivider) ...[
            Container(
              height: screenWidth * 0.08,
              width: 1.5,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              color: Colors.black.withOpacity(0.5),
            ),
          ],

          // 👈 TextFormField
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.040,
                fontWeight: FontWeight.w500,
                color: textColor, // Use custom text color
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  fontSize: screenWidth * 0.034,
                  fontWeight: FontWeight.w500,
                  color: hintTextColor, // Use custom hintText color
                ),
                border: InputBorder.none,
                suffixIcon: suffix,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
