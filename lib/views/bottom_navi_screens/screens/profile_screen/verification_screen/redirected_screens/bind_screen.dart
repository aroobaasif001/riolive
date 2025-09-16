import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';

class BindPhoneScreen extends StatelessWidget {
  const BindPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ init responsive helper (baseline: 375 x 812)
    R.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Top image
              Container(
                width: double.infinity,
                height: R.h(260),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/bind.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(R.r(50)),
                  ),
                ),
              ),

              SizedBox(height: R.h(35)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(24)),
                child: CustomText(
                  "Bind a Phone",
                  fontType: AppFont.poppins,
                  fontSize: R.sp(24),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: R.h(24)),

              // 📱 Phone field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(24)),
                child: Container(
                  height: R.h(55),
                  padding: EdgeInsets.symmetric(horizontal: R.w(12)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(R.r(30)),
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: '+1',
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),
                        items: <String>['+1', '+92', '+44', '+91'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CustomText(
                              value,
                              fontSize: R.sp(16),
                              color: Colors.black,
                              fontType: AppFont.poppins,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {},
                      ),
                      SizedBox(width: R.w(10)),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: R.sp(15)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Please enter your phone number",
                            hintStyle: TextStyle(
                              fontSize: R.sp(15),
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: R.h(20)),

              // ✅ Next button (image bg)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(25)),
                child: Container(
                  width: double.infinity,
                  height: R.h(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(R.r(30)),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/button_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      "Next",
                      fontSize: R.sp(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontType: AppFont.poppins,
                    ),
                  ),
                ),
              ),

              SizedBox(height: R.h(20)),

              // Terms text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    CustomText(
                      "By using Riolive, you agree to the ",
                      fontSize: R.sp(10.5),
                      color: Colors.black,
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "Terms Of Services ",
                      fontSize: R.sp(10.5),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9557F9),
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "And ",
                      fontSize: R.sp(10.5),
                      color: Colors.black,
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "Privacy Policy",
                      fontSize: R.sp(10.5),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9557F9),
                      fontType: AppFont.poppins,
                    ),
                  ],
                ),
              ),
            ],
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
