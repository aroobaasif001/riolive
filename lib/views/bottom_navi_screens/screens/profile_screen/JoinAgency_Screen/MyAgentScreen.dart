import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../../../customwidgets/custom_gradient_button.dart';
import 'AgencyManagementScreen.dart';

class MyAgentScreen extends StatelessWidget {
  const MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB6F2E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 🔙 Back navigation
          },
        ),
        centerTitle: true,
        title: const CustomText(
          "My Agent",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: const [
          Icon(Icons.headset_mic_outlined, color: Colors.green),
          SizedBox(width: 12),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile image
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/images/maprofle.png"),
            ),
            const SizedBox(height: 10),

            // Agency title
            const CustomText(
              "Rio Agency",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: CustomText(
                "You have already become a member of the [Rio Agency]. "
                    "Please contact official customer service or the agency leader "
                    "if you have any problems",
                fontSize: 13,
                textAlign: TextAlign.center,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 First Gradient Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  // Left text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Agent RioLive ID",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        "ID: 3236586",
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  // Copy icon
                  Icon(Icons.copy, color: Colors.white, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Second Gradient Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE496FF), Color(0xFF8EC2FB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  // Left text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Agent WhatsApp",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        "+91 32365865",
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  // Copy icon
                  Icon(Icons.copy, color: Colors.white, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Custom Gradient Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomGradientButton(
                text: "Continue",
                width: 150,
                height: 52,
                onPressed: () {
                  Get.to(()=> AgencyManagementScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
