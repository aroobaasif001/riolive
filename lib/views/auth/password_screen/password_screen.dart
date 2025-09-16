import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtextformfield.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../controller/signup_controller.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.find<SignUpController>(); // Get existing controller

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/backgrondimage.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image(
                              image: AssetImage('assets/icons/backarrow.png'),
                              height: 24,
                              width: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        CustomText(
                          'Sign up with Email Address',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        SizedBox(height: 60),
                        CustomTextFormField(
                          controller: signUpController.password,
                          hintText: 'Password',
                          obscureText: true,
                          prefix: Image(
                            image: AssetImage('assets/icons/passwordicon.png'),
                            height: 22,
                            width: 28,
                          ),
                          suffix: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          controller: signUpController.confirmPassword,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          prefix: Image(
                            image: AssetImage('assets/icons/passwordicon.png'),
                            height: 22,
                            width: 28,
                          ),
                          suffix: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomText(
                          'Set 8-16 letter as a password',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(height: 120),
                        // Show loading indicator or button
                        Obx(() {
                          return signUpController.isLoading.value
                              ? CircularProgressIndicator()
                              : CustomButton(
                                  height: 57,
                                  width: 386,
                                  text: 'Next',
                                  onPressed: signUpController.signUp,
                                );
                        }),
                        SizedBox(height: 16),
                        CustomText(
                          'By using Riolive, you agree to the',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        CustomText(
                          'Terms of Services And Privacy Policy',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
