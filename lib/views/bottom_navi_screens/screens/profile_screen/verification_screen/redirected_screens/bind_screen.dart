import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';

class BindPhoneScreen extends StatelessWidget {
  const BindPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffb6f2e3), // Transparent so gradient visible
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back action
          },
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
                  'Bind a Phone',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Custom Phone TextField
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomTextField(hintText: '',),
              ),

              const SizedBox(height: 20),

              // 🔹 Next button with gradient
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: CustomGradientButton(
                  text: "Next",
                  width: double.infinity,
                  height: 50,
                  onPressed: () {},
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
                      TextSpan(text: 'By using Riolive, you agree to the '),
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
  const CustomTextField({super.key, required String hintText});

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
