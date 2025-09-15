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
    // 🔹 initialize responsive helper (baseline: 375x812)
    R.init(context);

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
        title: CustomText(
          "Authentication",
          fontSize: R.sp(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      body: CustomContainer(
        height: size.height,
        width: size.width,
        image: const DecorationImage(
          image: AssetImage("assets/images/bg11.png"),
          fit: BoxFit.cover,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: R.w(20),
              vertical: R.h(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: R.h(20)),

                // 🔹 My Authentication + Description (left) + Illustration (right)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "My Authentication",
                            fontSize: R.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: R.h(8)),
                          CustomText(
                            "To protect you and other account security.\n"
                                "we recommend you to complete verification.",
                            fontSize: R.sp(13),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: R.w(10)),
                    Image.asset(
                      "assets/images/auth_illustration.png",
                      height: R.w(90),
                      width: R.w(90),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                SizedBox(height: R.h(40)),

                // 1️⃣ Face Authentication
                CustomContainer(
                  height: R.h(90),
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(R.r(16)),
                  conColor: Colors.white,
                  border: Border.all(
                    color: const Color(0x66000000),
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: R.w(12),
                    vertical: R.h(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/face7.png",
                          height: R.w(40), width: R.w(40)),
                      SizedBox(width: R.w(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Face Authentication",
                              fontSize: R.sp(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: R.h(9)),
                            CustomText(
                              "Please complete real person verification...",
                              fontSize: R.sp(12),
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
                        height: R.h(36),
                        width: R.w(70),
                        borderRadius: R.r(20),
                        gradientColors: const [
                          Color(0xFF8EC2FB),
                          Color(0xFFE496FF)
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: R.h(16)),

                // 2️⃣ Bind a Phone
                CustomContainer(
                  height: R.h(90),
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(R.r(16)),
                  conColor: Colors.white,
                  border: Border.all(
                    color: const Color(0x66000000),
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: R.w(12),
                    vertical: R.h(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/bind7.png",
                          height: R.w(40), width: R.w(40)),
                      SizedBox(width: R.w(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Bind a Phone",
                              fontSize: R.sp(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: R.h(9)),
                            CustomText(
                              "Please bind mobile number...",
                              fontSize: R.sp(12),
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
                        height: R.h(36),
                        width: R.w(70),
                        borderRadius: R.r(20),
                        gradientColors: const [
                          Color(0xFF8EC2FB),
                          Color(0xFFE496FF)
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: R.h(16)),

                // 3️⃣ Join Agency
                CustomContainer(
                  height: R.h(90),
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(R.r(16)),
                  conColor: Colors.white,
                  border: Border.all(
                    color: const Color(0x66000000),
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: R.w(12),
                    vertical: R.h(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/bind7.png",
                          height: R.w(40), width: R.w(40)),
                      SizedBox(width: R.w(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Join Agency",
                              fontSize: R.sp(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: R.h(9)),
                            CustomText(
                              "Please enter agency invite code",
                              fontSize: R.sp(11),
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
                        height: R.h(36),
                        width: R.w(70),
                        borderRadius: R.r(20),
                        gradientColors: const [
                          Color(0xFF8EC2FB),
                          Color(0xFFE496FF)
                        ],
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

/// =================================================================
///               SUPER LIGHTWEIGHT RESPONSIVE UTILS
///   Baseline: 375 x 812 (iPhone-ish). No 3rd-party packages.
/// =================================================================
class R {
  static late double _sw; // screen width
  static late double _sh; // screen height
  static late double _ws; // width scale vs baseline
  static late double _hs; // height scale vs baseline

  static void init(BuildContext context, {double designW = 375, double designH = 812}) {
    final size = MediaQuery.of(context).size;
    _sw = size.width;
    _sh = size.height;
    _ws = _sw / designW;
    _hs = _sh / designH;
  }

  /// Width-based scaling (best for horizontal paddings, button widths, icons)
  static double w(double px) => px * _ws;

  /// Height-based scaling (best for vertical paddings, heights)
  static double h(double px) => px * _hs;

  static double sp(double px) => px * _ws;

  static double r(double px) => px * _ws;
}
