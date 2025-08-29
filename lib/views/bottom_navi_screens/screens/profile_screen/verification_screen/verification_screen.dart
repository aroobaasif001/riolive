import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/views/bottom_navi_screens/screens/agency_screens/agency_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/bind_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/verification_screen/redirected_screens/face_auth_screen.dart';

import '../JoinAgency_Screen/JoinAgencyScreen.dart';
// ✅ import custom button

import '../../../../../customwidgets/customtext.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔙 AppBar Row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: CustomText(
                          "Authentication",
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                /// 🔐 Info Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "My Authentication",
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 20),
                        CustomText(
                          "To protect you and other \naccount security, we \nrecommend you to complete\nverification.",
                          fontSize: size.width * 0.035,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/verification.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// 🔹 Auth Options
                _buildAuthCard(
                  context,
                  imageAsset: 'assets/images/v2.png',
                  title: "Face Authentication",
                  subtitle: "Please complete real person ...",
                  buttonText: "Go",
                  onPressed: () {
                    Get.to(() => Faceauthenticationscreen());
                  },
                ),
                _buildAuthCard(
                  context,
                  imageAsset: 'assets/images/v2.png',
                  title: "Bind a Phone",
                  subtitle: "Please bind mobile number...",
                  buttonText: "Bind",
                  onPressed: () {
                    Get.to(() => BindPhoneScreen());
                  },
                ),
                _buildAuthCard(
                  context,
                  imageAsset: 'assets/images/v2.png',
                  title: "Join Agency",
                  subtitle: "Please enter agency invite code",
                  buttonText: "Join",
                  onPressed: () {
                    Get.to(() => JoinAgencyScreen());
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgencyScreen(),
                      ),
                    );*/
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Auth Card Widget
  Widget _buildAuthCard(
    BuildContext context, {
    required String imageAsset,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF0EEF4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageAsset, width: 44, height: 44, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                const SizedBox(height: 4),
                CustomText(subtitle, fontSize: size.width * 0.032, color: Colors.black54),
              ],
            ),
          ),
          CustomGradientButton(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }
}
