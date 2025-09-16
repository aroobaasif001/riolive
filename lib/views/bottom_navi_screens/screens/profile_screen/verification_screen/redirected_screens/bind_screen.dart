import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';

class BindPhoneScreen extends StatelessWidget {
  const BindPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Top image with curve
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(1),
              ),
              child: Image.asset(
                "assets/images/bind.png",
                width: 551.14,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Title
            // 🔹 Title
            Align(
              alignment: Alignment.centerLeft, // ✅ left side
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: CustomText(
                  "Bind a Phone",
                  fontType: AppFont.poppins,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.start, // ✅ text also starts from left
                ),
              ),
            ),




            const SizedBox(height: 24),

            // 🔹 Phone Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 57,
                width: 387,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: '+1',
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down_outlined,
                          color: Colors.black),
                      items: <String>['+1', '+92', '+44', '+91']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: CustomText(
                            value,
                            fontSize: 16,
                            color: Colors.black,
                            fontType: AppFont.poppins,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {},
                    ),
                    const SizedBox(width: 10),
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
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Gradient Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: CustomGradientButton(

                height: 57,
                width: 386,
                text: "Next",
                fontSize: 24,
                borderRadius: 22,

                onPressed: () {},
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Terms and Privacy Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31.5),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: const [
                  CustomText(
                    "By using Riolive, you agree to the ",
                    fontSize: 10.5,
                    color: Colors.black,
                    fontType: AppFont.poppins,
                  ),
                  CustomText(
                    "Terms Of Services ",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9557F9),
                    fontType: AppFont.poppins,
                  ),
                  CustomText(
                    "And ",
                    fontSize: 12,
                    color: Colors.black,
                    fontType: AppFont.poppins,
                  ),
                  CustomText(
                    "Privacy Policy",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9557F9),
                    fontType: AppFont.poppins,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
