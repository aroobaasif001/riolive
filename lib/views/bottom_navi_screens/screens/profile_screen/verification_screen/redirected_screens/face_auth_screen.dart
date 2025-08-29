import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../customwidgets/custom_gradient_button.dart';

class Faceauthenticationscreen extends StatelessWidget {
  const Faceauthenticationscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFB6F2E3),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🔹 Header with circle image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    child: ClipOval(
                      child: CustomImage(
                        path: 'assets/images/face_auth1.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const CustomText(
                    text: "Please upload a clear photo of yourself first",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20, width: 3),

                  /// 🔹 Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          "Upload Picture",
                          'assets/images/face_auth2.png',
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: _buildActionButton(
                          "Selfie With your ID",
                          'assets/images/face_auth2.png',
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: _buildActionButton(
                          "Upload your Short video",
                          'assets/images/face_auth2.png',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFF9055FA),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: const CustomText(
                          text: "Upload a photo of yourself",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9055FA),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomGradientButton(
                          text: "Start To Certificate",
                          width: double.infinity,
                          height: 50,
                          onPressed: () {}
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

  /// 🔹 Local action button (uses CustomText + CustomImage)
  Widget _buildActionButton(String label, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImage(
          path: imagePath,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Custom Image Widget
class CustomImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.path,
    this.width = 50,
    this.height = 50,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
    );
  }
}