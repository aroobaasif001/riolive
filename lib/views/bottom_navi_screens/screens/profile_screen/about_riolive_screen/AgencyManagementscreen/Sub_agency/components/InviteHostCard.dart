import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';

class InviteHostCard extends StatelessWidget {
  const InviteHostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: const Color(0xffE6F1FC),
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('Invite Host', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: CustomContainer(
                  conColor: const Color(0xffE6F1FC),
                  borderRadius: BorderRadius.circular(10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: const [
                      CustomText('Number of Host', fontSize: 12, color: Colors.black87),
                      Spacer(),
                      Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CustomGradientButton(
                text: "Invite Agency",
                width: 100,
                height: 30,
                borderRadius: 24,
                gradientColors: const [Color(0xff11876B), Color(0xffB0FF4B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                textColor: Colors.black,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
