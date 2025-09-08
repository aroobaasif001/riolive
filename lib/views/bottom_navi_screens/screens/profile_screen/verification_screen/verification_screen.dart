import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/bind_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/face_auth_screen.dart';

import '../agency_screen1/agency_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: const CustomText(
          "Authentication",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: CustomContainer(
        height: size.height,
        width: size.width,
        image: const DecorationImage(
          image: AssetImage("assets/images/bg11.png"), // 👈 background image path
          fit: BoxFit.cover,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 🔹 My Authentication + Description (left) + Illustration (right)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "My Authentication",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8),
                          CustomText(
                            "To protect you and other account security.\n"
                                "we recommend you to complete verification.",
                            fontSize: 13,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      "assets/images/auth_illustration.png",
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 1️⃣ Face Authentication
                CustomContainer(
                  height: 90,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  conColor: Colors.white,
                  border: Border.all(
                    color: Color(0x66000000),
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/images/face7.png", height: 40, width: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Face Authentication",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: 9),
                            CustomText(
                              "Please complete real person verification...",
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      CustomGradientButton(
                        text: "Go",
                        onPressed: () {
                          Get.to(() => const Faceauthenticationscreen());
                        },
                        height: 36,
                        width: 70,
                        borderRadius: 20,
                        gradientColors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2️⃣ Bind a Phone
                CustomContainer(
                  height: 90,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  conColor: Colors.white,
                  border: Border.all(           // 👈 Black border added
                    color: Color(0x66000000),
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/images/bind7.png", height: 40, width: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Bind a Phone",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: 9),
                            CustomText(
                              "Please bind mobile number...",
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      CustomGradientButton(
                        text: "Bind",
                        onPressed: () {
                          Get.to(() => const BindPhoneScreen());
                        },
                        height: 36,
                        width: 70,
                        borderRadius: 20,
                        gradientColors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3️⃣ Join Agency
                CustomContainer(
                  height: 90,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  conColor: Colors.white,
                  border: Border.all(
                    color: Color(0x66000000),
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/images/bind7.png", height: 40, width: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Join Agency",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: 9),
                            CustomText(
                              "Please enter agency invite code",
                              fontSize: 11,

                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      CustomGradientButton(
                        text: "Join",
                        onPressed: () {
                          Get.to(() => const AgencyScreen());
                        },
                        height: 36,
                        width: 70,
                        borderRadius: 20,
                        gradientColors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
