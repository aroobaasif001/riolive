import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';

class BindPhoneScreen extends StatelessWidget {
  const BindPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top background with image
              Container(
                width: double.infinity,
                height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bind.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  text: 'Bind a Phone',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Custom Phone TextField
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomTextField(),
              ),

              const SizedBox(height: 20),

              // 🔹 Next button with gradient
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CustomGradientButton(
                    text: "Next",
                    width: double.infinity,
                    height: 50,
                    onPressed: () {}
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Terms and Privacy with custom colors
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    children: const [
                      TextSpan(
                          text:
                          'By using Riolive, you agree to the '),
                      TextSpan(
                        text: 'Terms Of Services',
                        style: TextStyle(
                          color: Color(0xFF9557F9), // purple
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF9557F9), // purple
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =========================
/// 🔥 Custom Widgets
/// =========================

/// Custom Text Widget
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
      style: GoogleFonts.poppins(
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

/// Custom Phone TextField Widget
class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),

          // Country code dropdown
          DropdownButton<String>(
            value: '+1',
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: <String>['+1', '+92', '+44', '+91'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (val) {},
          ),

          const SizedBox(width: 5),

          // Divider
          Container(
            height: 25,
            width: 1,
            color: Colors.black.withOpacity(0.3),
          ),

          const SizedBox(width: 10),

          // Input field
          const Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Please enter your phone number",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}