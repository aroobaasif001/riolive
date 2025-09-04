import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import 'customtext.dart';

Widget categoryTab(String categoryName, bool isSelected) {
  return GestureDetector(
    onTap: () {},
    child: CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // conColor: isSelected
      //     ? Colors.white.withOpacity(0.2)
      //     : Colors.transparent,
      child: CustomText(
        categoryName,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
        fontSize: 14,
      ),
    ),
  );
}
