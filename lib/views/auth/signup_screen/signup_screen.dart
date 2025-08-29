import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtextformfield.dart';
import 'package:riolive/customwidgets/termsagreement.dart';
import 'package:riolive/views/splashscreen/splash_screen.dart';

import '../../../controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(
      SignUpController(),
    ); // Initialize SignUpController

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/backgrondimage.png"),
              fit: BoxFit.fill, // 👈 Image poora screen cover karegi
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => SplashScreen());
                    },
                    child: Image(
                      image: AssetImage('assets/icons/backarrow.png'),
                      height: 24,
                      width: 30,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Image(
                  image: AssetImage('assets/icons/hellowtext.png'),
                  height: 48,
                  width: 113,
                ),
                SizedBox(height: 25),
                CustomTextFormField(
                  controller: signUpController.email,
                  hintText: 'Enter your email or phone number...',
                  prefix: Image(
                    image: AssetImage('assets/icons/emailicon.png'),
                    height: 22,
                    width: 28,
                  ),
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: signUpController.password,
                  hintText: 'Enter Password',
                  prefix: Image(
                    image: AssetImage('assets/icons/passwordicon.png'),
                    height: 22,
                    width: 28,
                  ),
                ),
                SizedBox(height: 110),
                // Show the loading indicator or the button
                Obx(() {
                  return signUpController.isLoading.value
                      ? CircularProgressIndicator() // Show loading indicator
                      : CustomButton(
                          height: 57,
                          width: 386,
                          text: 'SignUp',
                          onPressed:
                              signUpController.signUp, // Call the signUp method
                        );
                }),
                SizedBox(height: 16),
                TermsAgreement(showCheckbox: false),
                SizedBox(height: 20),
                // Display error message if any
                Obx(() {
                  return signUpController.errorMessage.value.isNotEmpty
                      ? Text(
                          signUpController.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                        )
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
