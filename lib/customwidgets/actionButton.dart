// Helper function to create action buttons (Follow button)
import 'package:flutter/material.dart';

import 'customtext.dart';

Widget actionButton(String label, Color color, Gradient gradient) {
  return GestureDetector(
    onTap: () {
      // Handle button action
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: CustomText(
          label,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
