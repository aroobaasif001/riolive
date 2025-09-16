import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';

class Faceauthenticationscreen extends StatelessWidget {
  const Faceauthenticationscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ init responsive helper (baseline 375x812)
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6F2E3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CustomText(
          "Authentication",
          fontSize: R.sp(20),
          fontWeight: FontWeight.bold,
          color: Colors.black,
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
        child: Padding(
          padding: EdgeInsets.all(R.w(16)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: R.h(60)),
                CircleAvatar(
                  radius: R.r(60),
                  backgroundColor: Colors.blue.shade100,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/face_auth1.png',
                      width: R.w(153),
                      height: R.w(153),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: R.h(10)),
                CustomText(
                  "Please upload a clear photo of yourself first",
                  fontSize: R.sp(13),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black.withOpacity(0.08),
                ),
                SizedBox(height: R.h(5)),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        "Upload Picture",
                        'assets/images/face_auth2.png',
                      ),
                    ),
                    SizedBox(width: R.w(5), height: R.h(20)),
                    Expanded(
                      child: _buildActionButton(
                        "Selfie With your ID",
                        'assets/images/face_auth2.png',
                      ),
                    ),
                    SizedBox(width: R.w(1)),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: R.h(10)),
                        child: _buildActionButton(
                          "Upload your \nShort video",
                          'assets/images/face_auth2.png',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: R.h(100)),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: Size(double.infinity, R.h(50)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(R.r(24)),
                          side: const BorderSide(
                            color: Color(0xFF9557F9),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: CustomText(
                        "Upload a photo of yourself",
                        fontSize: R.sp(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9055FA),
                      ),
                    ),
                    SizedBox(height: R.h(20)),
                    CustomGradientButton(
                      text: "Start to Certificate",
                      width: R.w(300),
                      height: R.h(50),
                      fontWeight: FontWeight.bold,
                      borderRadius: R.r(24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: R.w(50),
          height: R.w(50),
          fit: BoxFit.cover,
        ),
        SizedBox(height: R.h(12)),
        CustomText(
          label,
          fontSize: R.sp(10),
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          color: Colors.black87,
          maxLines: 2,
          softWrap: true,
        ),
      ],
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

  /// Font scaling (width-based by default)
  static double sp(double px) => px * _ws;

  /// Radius scaling (corners, circle sizes)
  static double r(double px) => px * _ws;
}
