import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class TopSummaryCard extends StatelessWidget {
  const TopSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: const Color(0xffEFD8D8),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomText("Alexander", fontSize: 16, fontWeight: FontWeight.bold),
                        const SizedBox(width: 4),
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const CustomText(
                            "Agency",
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const CustomText("ID: 10209804", fontSize: 12, color: Colors.black54),
                  ],
                ),
              ),
            ],
          ),

          // Agency Code (same-to-same layout)
          Center(
            child: CustomText(
              'Agency Code:   2XD56C',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.copy, color: Colors.black54, size: 14),

          const SizedBox(height: 5),
          const Divider(),

          // Support row
          Row(
            children: [
              Image.asset("assets/icons/supporticon.png", width: 20, height: 20),
              const SizedBox(width: 10),
              const CustomText("Support", fontSize: 14, fontWeight: FontWeight.bold),
              const Spacer(),
              CustomContainer(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xffE0F7E9),
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/images/rio2.png", width: 25, height: 25),
              ),
              const CustomText("Rio", fontSize: 14, fontWeight: FontWeight.bold),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 16),

          // Agency Level row
          Row(
            children: [
              Image.asset("assets/icons/bar_chart.png", width: 20, height: 20),
              const SizedBox(width: 10),
              const CustomText("Agency Level", fontSize: 14, fontWeight: FontWeight.bold),
              const Spacer(),
              const CustomText("A:16%", fontSize: 14, color: Colors.black87),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }
}
