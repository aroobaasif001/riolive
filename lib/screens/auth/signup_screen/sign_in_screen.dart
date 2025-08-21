import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtextformfield.dart';
import 'package:riolive/customwidgets/termsagreement.dart';
import 'package:riolive/screens/splashscreen/splash_screen.dart';
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
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
          ),child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Get.to(()=>SplashScreen());
                    },
                      child: Image(image: AssetImage('assets/icons/backarrow.png'),height: 24,width: 30,))),
              SizedBox(height: 24,),
              Image(image: AssetImage('assets/icons/hellowtext.png'),height: 48,width: 113,),
              SizedBox(height: 25,),
              CustomTextFormField(
                hintText: 'Enter your email or phone nu...',prefix: Image(image: AssetImage('assets/icons/emailicon.png'),height: 22,width: 28,),),
              SizedBox(height: 16,),
              CustomTextFormField(
                hintText: 'Enter Password',prefix: Image(image: AssetImage('assets/icons/passwordicon.png'),height: 22,width: 28,),),
              SizedBox(height: 110,),
              CustomButton(
                height: 57,
                width: 386,
                text: 'Next', onPressed:() {
              },),
              SizedBox(height: 16,),
              TermsAgreement(showCheckbox: false,),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
