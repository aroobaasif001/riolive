import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import '../../../../../customwidgets/CustomInputField.dart';
import '../../../../../customwidgets/custom_gradient_button.dart';

class CreateAgencyScreen extends StatelessWidget {
  const CreateAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ init responsive helper (baseline 375 x 812)
    R.init(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: CustomText(
          "Create an Agency",
          fontSize: R.sp(18),
          fontWeight: FontWeight.bold,
          color: Colors.black,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(R.w(16)),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: R.w(340), // 👈 content width clamp
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: R.h(80)),

                  // 🔹 Your RioLive ID
                  CustomText(
                    "*Your RioLive Id",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: R.h(6)),
                  CustomInputField(hintText: "ID Number"),

                  SizedBox(height: R.h(16)),

                  // 🔹 Verification Code + Get Button Inside Field
                  CustomText(
                    "RioLive Verification Code",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: R.h(6)),
                  TextField(
                    style: TextStyle(fontSize: R.sp(12)),
                    decoration: InputDecoration(
                      hintText: "Verification Code",
                      hintStyle: TextStyle(fontSize: R.sp(12), color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(R.r(30)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300.withOpacity(0.6),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: R.w(20),
                        vertical: R.h(14),
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: R.w(10)),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFD6FFF), Color(0xFF8EC2FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(R.r(20)),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // 👉 GET logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(R.r(20)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: R.w(12)),
                            minimumSize: Size(R.w(50), R.h(30)),
                          ),
                          child: Text(
                            "Get",
                            style: TextStyle(
                              fontSize: R.sp(12),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: R.h(16)),

                  // 🔹 Country
                  CustomText(
                    "Country",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: R.h(6)),
                  CustomInputField(
                    hintText: "Please enter Country",
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black54, size: R.sp(22)),
                  ),

                  SizedBox(height: R.h(16)),

                  // 🔹 Description
                  CustomText(
                    "Description",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: R.h(6)),
                   CustomInputField(hintText: "Please Add"),

                  SizedBox(height: R.h(16)),

                  // 🔹 WhatsApp
                  CustomText(
                    "WhatsApp",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: R.h(6)),
                  CustomInputField(
                    hintText: "Please fill in WhatsApp with country code",
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black54, size: R.sp(22)),
                  ),

                  SizedBox(height: R.h(24)),

                  // 🔹 Experience Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(R.w(16)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(R.r(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Experience",
                          fontSize: R.sp(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(height: R.h(12)),

                        // Radio Buttons Vertical
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: true,
                                  onChanged: (_) {},
                                  visualDensity: VisualDensity.compact,
                                ),
                                CustomText("Yes", fontSize: R.sp(12)),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: true,
                                  onChanged: (_) {},
                                  visualDensity: VisualDensity.compact,
                                ),
                                CustomText("No", fontSize: R.sp(12)),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: R.h(12)),

                        // Normal TextField (underline)
                        CustomText("Name of other Platforms:", fontSize: R.sp(12)),
                        SizedBox(height: R.h(6)),
                        TextField(
                          style: TextStyle(fontSize: R.sp(12)),
                          decoration: InputDecoration(
                            hintText: "Please enter",
                            hintStyle: TextStyle(fontSize: R.sp(12), color: Colors.black54),
                            border: const UnderlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: R.h(12)),
                        CustomText("Proof of cooperation (optional)", fontSize: R.sp(12)),
                        SizedBox(height: R.h(8)),
                        Container(
                          height: R.h(80),
                          width: R.w(100),
                          decoration: BoxDecoration(
                            color: const Color(0xffDDDDDD),
                            borderRadius: BorderRadius.circular(R.r(12)),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: R.h(30)),

                  // 🔹 Apply Gradient Button
                  CustomGradientButton(
                    text: "Apply",
                    onPressed: () {},
                    width: double.infinity,
                    height: R.h(50),
                    borderRadius: R.r(12),
                    gradientColors: const [Color(0xFFFD6FFF), Color(0xFF8EC2FB)],
                  ),

                  SizedBox(height: R.h(20)),

                  // 🔹 Warm Tips
                  CustomText(
                    "Warm Tips:",
                    fontSize: R.sp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  SizedBox(height: R.h(8)),

                  // 👉 Left padding for tips
                  Padding(
                    padding: EdgeInsets.only(left: R.w(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "1. Plz invite 5 valid hosts at least within a month after registration.",
                          fontSize: R.sp(12),
                          fontWeight: FontWeight.w400,
                          color: const Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: R.h(8)),
                        CustomText(
                          "2. Valid host: Live for over 2 hours daily at least on one day within a week.",
                          fontSize: R.sp(12),
                          fontWeight: FontWeight.w400,
                          color: const Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: R.h(10)),
                        CustomText(
                          "3. If active valid hosts is less than 5 in a month, platform holds the right to take follow-up action to the agency.",
                          fontSize: R.sp(12),
                          fontWeight: FontWeight.w400,
                          color: const Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      ],
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
