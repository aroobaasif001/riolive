// Helper function to create stat columns
import 'package:flutter/material.dart';

import 'customtext.dart';

Widget statColumn(String value, String title) {
  return Column(
    children: [
      CustomText(
        value,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18,
      ),
      CustomText(
        title,
        fontWeight: FontWeight.normal,
        color: Colors.grey[600]!,
        fontSize: 12,
      ),
    ],
  );
}
