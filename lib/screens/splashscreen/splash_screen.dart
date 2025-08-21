import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customdividerwithtext.dart';
import 'package:riolive/customwidgets/customgooglebutton.dart';
import 'package:riolive/customwidgets/termsagreement.dart';
import 'package:riolive/screens/auth/signup_screen/sign_in_screen.dart';
import 'package:riolive/utile/const.dart';
import '../../customwidgets/customcirclebutton.dart';
import '../../customwidgets/customtextformfield.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/backgrondimage.png"),
            fit: BoxFit.fill, // 👈 Image poora screen cover karegi
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/riolivetext.png'),height: 55,width: 200,),
            SizedBox(height: 196,),
            CustomGoogleButton(
              iconPath: 'assets/icons/Google.png',
              height: 57,
              width: 334,
              text: 'Sign in with Google',
              onPressed: () {
            },),
            SizedBox(height: 24,),
            CustomGoogleButton(
              iconPath: 'assets/icons/signinwithgoogleicon.png',
              iconSize: 27,
              height: 57,
              width: 334,
              text: 'Sign in with Account',
              onPressed: () {
                Get.to(()=>SignInScreen());
              },),
            SizedBox(height: 50,),
            CustomDividerWithText(),
            SizedBox(height: 24,),
            CustomCircleButton(
              size: 43,
              child:Image(image: AssetImage('assets/icons/device-mobile_24.png'),height: 27,width: 27,), onPressed: () {

            },),
            SizedBox(height: 24,),
            TermsAgreement(showCheckbox: true,),
          ],
        ),
      ),
    );
  }
}
