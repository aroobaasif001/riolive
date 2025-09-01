import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtextformfield.dart';
import 'package:riolive/customwidgets/termsagreement.dart';

import '../../../controller/signin_controller.dart';
import '../../splashscreen/splash_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signInController = Get.put(SignInController());

    return SafeArea(
      child: Scaffold(
        // (optional) explicit – default true hota hai
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgrondimage.png"),
              fit: BoxFit.fill,
            ),
          ),
          // ⬇️ Wrap existing Column with SingleChildScrollView
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // keyboard khulte hi bottom padding add ho jayegi
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30).copyWith(
              bottom: 30 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const SplashScreen());
                    },
                    child: const Image(
                      image: AssetImage('assets/icons/backarrow.png'),
                      height: 24,
                      width: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Image(
                  image: AssetImage('assets/icons/hellowtext.png'),
                  height: 48,
                  width: 113,
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  controller: signInController.email,
                  hintText: 'Enter your email or phone number...',
                  prefix: const Image(
                    image: AssetImage('assets/icons/emailicon.png'),
                    height: 22,
                    width: 28,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: signInController.password,
                  hintText: 'Enter Password',
                  prefix: const Image(
                    image: AssetImage('assets/icons/passwordicon.png'),
                    height: 22,
                    width: 28,
                  ),
                ),
                const SizedBox(height: 110),
                Obx(() {
                  return signInController.isLoading.value
                      ? const CircularProgressIndicator()
                      : CustomButton(
                    height: 57,
                    width: 386,
                    text: 'Next',
                    onPressed: signInController.signIn,
                  );
                }),
                const SizedBox(height: 16),
                const TermsAgreement(showCheckbox: false),
                const SizedBox(height: 20),
                Obx(() {
                  return signInController.errorMessage.value.isNotEmpty
                      ? Text(
                    signInController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  )
                      : const SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
