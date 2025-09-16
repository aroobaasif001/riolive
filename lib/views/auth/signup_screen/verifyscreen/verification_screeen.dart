import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../../controller/signup_controller.dart';
import '../../../../customwidgets/customOtpbubblesbar.dart';

class VerificationScreeen extends StatelessWidget {
  const VerificationScreeen({super.key});

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

            // ⬇️ ADDED: Wrap Column so it scrolls & respects keyboard height
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
                        SizedBox(height: 138),
                        CustomText('Verify', fontSize: 36, fontWeight: FontWeight.w600),
                        CustomText(
                          'Please enter the 4-digit code sent to your email',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 41),
                        OtpBubblesInput(
                          length: 4,
                          diameter: 62,
                          strokeWidth: 2.5,
                          onChanged: (code) {
                            signUpController.otp.text = code;
                          },
                          onCompleted: (code) {
                            signUpController.otp.text = code;
                          },
                        ),
                        SizedBox(height: 42),
                        // Show loading indicator or button
                        Obx(() {
                          return signUpController.isOtpLoading.value
                              ? CircularProgressIndicator()
                              : CustomButton(
                                  height: 57,
                                  width: 207,
                                  text: 'Submit',
                                  onPressed: signUpController.verifyOtp,
                                );
                        }),
                        SizedBox(height: 34),
                        GestureDetector(
                          onTap: signUpController.resendOtp,
                          child: CustomText(
                            'Resend OTP',
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Color(0xffFFFFFF),
                            letterSpacing: 1,
                          ),
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
            // ⬆️ Column children untouched, sirf wrappers add hue
          ),
        ),
      ),
    );
  }
}
