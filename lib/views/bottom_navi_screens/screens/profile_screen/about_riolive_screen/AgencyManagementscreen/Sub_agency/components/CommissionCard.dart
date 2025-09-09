import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class CommissionCard extends StatelessWidget {
  const CommissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: const Color(0xFFB1C2F0),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              CustomText('My Commission', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
              Spacer(),
              CustomText('History list', fontSize: 12, color: Colors.black54),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: Colors.black54),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.monetization_on, color: Color(0xffFDD835), size: 20),
              SizedBox(width: 6),
              CustomText('0', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
