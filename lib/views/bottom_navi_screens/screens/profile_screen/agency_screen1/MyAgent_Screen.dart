import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';

class MyAgentScreen extends StatelessWidget {
  const MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Init responsive helper (baseline 375x812)
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFB6F2E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CustomText(
          "My Agent",
          fontSize: R.sp(18),
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Icon(Icons.headset_mic_outlined, color: Colors.green, size: R.sp(22)),
          SizedBox(width: R.w(12)),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: R.w(20)),
          child: Column(
            children: [
              SizedBox(height: R.h(20)),

              // Profile image
              CircleAvatar(
                radius: R.r(40),
                backgroundImage: const AssetImage("assets/images/maprofle.png"),
              ),
              SizedBox(height: R.h(10)),

              // Agency title
              CustomText(
                "Rio Agency",
                fontSize: R.sp(18),
                fontWeight: FontWeight.bold,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(30), vertical: R.h(10)),
                child: CustomText(
                  "You have already become a member of the [Rio Agency]. "
                      "Please contact official customer service or the agency leader "
                      "if you have any problems",
                  fontSize: R.sp(13),
                  textAlign: TextAlign.center,
                  color: Colors.black54,
                  softWrap: true,
                  maxLines: 4,
                ),
              ),

              SizedBox(height: R.h(20)),

              // 🔹 First Gradient Container
              Container(
                margin: EdgeInsets.symmetric(horizontal: R.w(30)),
                padding: EdgeInsets.all(R.w(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(R.r(12)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Agent RioLive ID",
                          fontSize: R.sp(15),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        SizedBox(height: R.h(5)),
                        CustomText(
                          "ID: 3236586",
                          fontSize: R.sp(13),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    // Copy icon
                    Icon(Icons.copy, color: Colors.white, size: R.sp(18)),
                  ],
                ),
              ),

              SizedBox(height: R.h(15)),

              // 🔹 Second Gradient Container
              Container(
                margin: EdgeInsets.symmetric(horizontal: R.w(30)),
                padding: EdgeInsets.all(R.w(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(R.r(12)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE496FF), Color(0xFF8EC2FB)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Agent WhatsApp",
                          fontSize: R.sp(15),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        SizedBox(height: R.h(5)),
                        CustomText(
                          "+91 32365865",
                          fontSize: R.sp(13),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    // Copy icon
                    Icon(Icons.copy, color: Colors.white, size: R.sp(18)),
                  ],
                ),
              ),

              SizedBox(height: R.h(30)),

              // 🔹 Custom Gradient Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(40)),
                child: CustomGradientButton(
                  text: "Continue",
                  width: R.w(150),
                  height: R.h(52),
                  borderRadius: R.r(24),
                  onPressed: () {
                    Get.to(() => const AgencyManagementScreen());
                  },
                ),
              ),

              SizedBox(height: R.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}

/// =================================================================
///                    LIGHTWEIGHT RESPONSIVE UTILS
///   Baseline: 375 x 812 (iPhone-ish). No extra packages.
/// =================================================================
class R {
  static late double _sw; // screen width
  static late double _sh; // screen height
  static late double _ws; // width scale
  static late double _hs; // height scale

  static void init(BuildContext context, {double designW = 375, double designH = 812}) {
    final size = MediaQuery.of(context).size;
    _sw = size.width;
    _sh = size.height;
    _ws = _sw / designW;
    _hs = _sh / designH;
  }

  /// Width-based scaling (horizontal paddings, widths, icons)
  static double w(double px) => px * _ws;

  /// Height-based scaling (vertical paddings, heights)
  static double h(double px) => px * _hs;

  /// Font scaling (usually width-based feels better)
  static double sp(double px) => px * _ws;

  /// Radius scaling (corner radius, circular sizes)
  static double r(double px) => px * _ws;
}
