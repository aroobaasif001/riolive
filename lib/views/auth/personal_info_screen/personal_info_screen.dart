import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtextformfield.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../controller/signup_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

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
                        SizedBox(height: 20),
                        CustomText(
                          'Complete your profile',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        // Profile Picture Circle
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              image: AssetImage('assets/images/girl_img1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        CustomTextFormField(
                          controller: signUpController.username,
                          hintText: 'User name xyz',
                        ),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          controller: signUpController.age,
                          hintText: 'Select age',
                          keyboardType: TextInputType.number,
                          suffix: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30),
                        CustomText(
                          'What is your gender?',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        // Gender Selection with reactive UI
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Male Option
                            GestureDetector(
                              onTap: () => signUpController.selectGender('male'),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: signUpController.selectedGender.value == 'male' 
                                          ? Colors.blue.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: signUpController.selectedGender.value == 'male' 
                                            ? Colors.blue 
                                            : Colors.white, 
                                        width: signUpController.selectedGender.value == 'male' ? 3 : 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/avatar.png', // Male avatar
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    'Male',
                                    fontSize: 16,
                                    fontWeight: signUpController.selectedGender.value == 'male' 
                                        ? FontWeight.w700 
                                        : FontWeight.w500,
                                    color: signUpController.selectedGender.value == 'male' 
                                        ? Colors.blue 
                                        : Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 60),
                            CustomText(
                              'Or',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            SizedBox(width: 60),
                            // Female Option
                            GestureDetector(
                              onTap: () => signUpController.selectGender('female'),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: signUpController.selectedGender.value == 'female' 
                                          ? Colors.pink.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: signUpController.selectedGender.value == 'female' 
                                            ? Colors.pink 
                                            : Colors.white, 
                                        width: signUpController.selectedGender.value == 'female' ? 3 : 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/girl_img1.png', // Female avatar
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    'Female',
                                    fontSize: 16,
                                    fontWeight: signUpController.selectedGender.value == 'female' 
                                        ? FontWeight.w700 
                                        : FontWeight.w500,
                                    color: signUpController.selectedGender.value == 'female' 
                                        ? Colors.pink 
                                        : Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                        SizedBox(height: 30),
                        CustomText(
                          'Lorem ipsum is simply dummy text of the',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        CustomText(
                          'printing and typesetting industry Lorem',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(height: 20),
                        CustomTextFormField(
                          controller: signUpController.invitationNumber,
                          hintText: 'Invitation Number',
                        ),
                        SizedBox(height: 60),
                        // Show loading indicator or button
                        Obx(() {
                          return signUpController.isLoading.value
                              ? CircularProgressIndicator()
                              : CustomButton(
                                  height: 57,
                                  width: 207,
                                  text: 'Start Journey',
                                  onPressed: signUpController.completeSignup,
                                );
                        }),
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
