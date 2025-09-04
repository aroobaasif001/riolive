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
                height: 260,
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

              const SizedBox(height: 35),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  "Bind a Phone",
                  fontType: AppFont.poppins,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.start, // ✅ left align
                ),
              ),



              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 55,
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
                        icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),
                        items: <String>['+1', '+92', '+44', '+91'].map((String value) {
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


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/button_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      "Next",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontType: AppFont.poppins,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: const [
                    CustomText(
                      "By using Riolive, you agree to the ",
                      fontSize:  10.5,
                      color: Colors.black,
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "Terms Of Services ",
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9557F9),
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "And ",
                      fontSize: 10.5,
                      color: Colors.black,
                      fontType: AppFont.poppins,
                    ),
                    CustomText(
                      "Privacy Policy",
                      fontSize: 10.5,
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
      ),
    );
  }
}
