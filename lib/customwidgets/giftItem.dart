import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import 'customtext.dart';

Widget giftItem(
  String name,
  String price,
  String imagePath, {
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CustomContainer(
      padding: const EdgeInsets.all(8),
      conColor: isSelected
          ? Colors.white.withOpacity(0.08)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected ? Colors.white.withOpacity(0.10) : Colors.transparent,
        width: 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomContainer(
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 2),
          CustomText(
            name,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 8,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/diamond_icon 2 1.png',
                height: 10,
                width: 10,
              ),
              const SizedBox(width: 2),
              CustomText(
                price,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 8,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
