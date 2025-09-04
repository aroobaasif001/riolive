// Helper function to create round action buttons
import 'package:flutter/material.dart';

Widget roundActionButton(String imagePath) {
  return GestureDetector(
    onTap: () {
      // Handle button action
    },
    child: Container(
      width: 50,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFB388F5), // Purple-ish background (matching)
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Outer shadow (bottom right)
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          // Outer highlight (top left)
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: 30,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
