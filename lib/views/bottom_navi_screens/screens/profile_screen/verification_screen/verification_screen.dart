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
    final height = size.height;
    final width = size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black, size: width * 0.06),
        ),
        centerTitle: true,
        title: CustomText(
          "Authentication",
          fontSize:  20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: CustomContainer(
        height: height,
        width: width,
        image: const DecorationImage(
          image: AssetImage("assets/images/bg11.png"),
          fit: BoxFit.cover,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),

                // My Authentication Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "My Authentication",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: height * 0.02),
                          CustomText(
                            "To protect you and other account security. "
                                "we recommend you to complete verification.",
                            fontSize: 16,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Image.asset(
                      "assets/images/auth_illustration.png",
                      height: 106.42,
                      width: 95.03,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),

                // Face Authentication
                _buildOption(
                  context,
                  width: width,
                  height: height,
                  icon: "assets/images/face7.png",
                  title: "Face Authentication",
                  subtitle: "Please complete real person verification...",
                  buttonText: "Go",
                  onTap: () => Get.to(() => const Faceauthenticationscreen()),
                ),
                SizedBox(height: height * 0.02),

                // Bind a Phone
                _buildOption(
                  context,
                  width: width,
                  height: height,
                  icon: "assets/images/bind7.png",
                  title: "Bind a Phone",
                  subtitle: "Please bind mobile number...",
                  buttonText: "Bind",
                  onTap: () => Get.to(() => const BindPhoneScreen()),
                ),
                SizedBox(height: height * 0.02),

                // Join Agency
                _buildOption(
                  context,
                  width: width,
                  height: height,
                  icon: "assets/images/bind7.png",
                  title: "Join Agency",
                  subtitle: "Please enter agency invite code",
                  buttonText: "Join",
                  onTap: () => Get.to(() => const AgencyScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required double width,
        required double height,
        required String icon,
        required String title,
        required String subtitle,
        required String buttonText,
        required VoidCallback onTap,
      }) {
    return CustomContainer(
      height: 105,
      width: 385,
      borderRadius: BorderRadius.circular(16),
      conColor: Colors.white,
      border: Border.all(color: const Color(0x66000000), width: 1),
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
      child: Row(
        children: [
          Image.asset(icon, height: 46, width: 46),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                SizedBox(height: height * 0.01),
                CustomText(
                  subtitle,
                  fontSize: width * 0.04,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          CustomGradientButton(
            text: buttonText,
            onPressed: onTap,
            fontSize: 16,   // 👈 text size fix at 16
            height: 40,
            width: 73,
            borderRadius: 20,
            gradientColors: const [Color(0xFF8EC2FB), Color(0xFFE496FF)],
          ),

        ],
      ),
    );
  }
}
