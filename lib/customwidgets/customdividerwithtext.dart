import 'package:flutter/material.dart';

import 'customtext.dart'; // 👈 yahan apka CustomText import karo

class CustomDividerWithText extends StatelessWidget {
  final String text;
  const CustomDividerWithText({super.key, this.text = "More Login Methods"});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        // Left Divider
        const Expanded(child: Divider(color: Colors.white, thickness: 1, endIndent: 10)),

        // Center CustomText
        CustomText(
          text,
          fontSize: screenWidth * 0.04, // responsive
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),

        // Right Divider
        const Expanded(child: Divider(color: Colors.white, thickness: 1, indent: 10)),
      ],
    );
  }
}
