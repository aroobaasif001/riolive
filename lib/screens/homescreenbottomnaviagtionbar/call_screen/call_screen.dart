import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customnavbar.dart';
import 'package:riolive/customwidgets/customtext.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/callscreenbgimage.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              CustomNavBar(),
              SizedBox(height: 97,),
              Image(image: AssetImage('assets/images/CIRCLE LOGO.png'),height: 310,width: 310,),
              SizedBox(height: 54,),
              CustomText(text: 'Match Random Video Call',fontSize: 24,fontWeight: FontWeight.w700,color: Color(0xff5EBFEF),),
              SizedBox(height: 57,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image(image: AssetImage('assets/icons/diamondicon.png'),height: 20,width: 27,),
                SizedBox(width: 5,),
                CustomText(text: '800/main',fontWeight: FontWeight.w600,fontSize: 24,color: Color(0xff60ED59),)
              ],),
              SizedBox(height: 41,),
              Image(image: AssetImage('assets/icons/phoneicon.png'),height: 80,width: 80,),

            ],
          ),
        ),
      ),
    );
  }
}
