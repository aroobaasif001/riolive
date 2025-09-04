// Helper function to create medal icons
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

Widget medalIcon(String imagePath) {
  return CustomContainer(
    width: 40,
    height: 40,
    // decoration: BoxDecoration(
    // shape: BoxShape.circle,
    // border: Border.all(color: Colors.white, width: 2),
    // ),
    child: Image.asset(imagePath),
  );
}
