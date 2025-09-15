import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'MyAgent_Screen.dart';

class JoinAgencyScreen extends StatelessWidget {
  const JoinAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ init responsive helper (baseline: 375 x 812)
    R.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "Join Agency",
          fontSize: R.sp(18),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg11.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: R.w(24)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Title
                  CustomText(
                    "Plz add agency ID",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  SizedBox(height: R.h(25)),

                  // 🔹 Input
                  SizedBox(
                    width: R.w(230),
                    child: TextField(
                      style: TextStyle(fontSize: R.sp(12)),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: R.sp(10),
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(R.r(12)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: R.w(12),
                          vertical: R.h(8),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: R.h(50)),

                  // 🔹 Helper text
                  CustomText(
                    "Plz input agency ID if you have no agent, plz input ID: 123456",
                    fontSize: R.sp(9),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: R.h(30)),

                  // 🔹 Gradient Button
                  Container(
                    width: R.w(160),
                    height: R.h(50),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFD6FFF), Color(0xFF8EC2FB)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(R.r(25)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const MyAgentScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(R.r(25)),
                        ),
                      ),
                      child: CustomText(
                        "Join",
                        fontSize: R.sp(14),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
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

  /// Width-based scaling (horizontal paddings, widths, icons)
  static double w(double px) => px * _ws;

  /// Height-based scaling (vertical paddings, heights)
  static double h(double px) => px * _hs;

  /// Font scaling (typically width-based feels better)
  static double sp(double px) => px * _ws;

  /// Radius scaling (corner radius, circular sizes)
  static double r(double px) => px * _ws;
}
