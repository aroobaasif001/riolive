import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/screens/auth/signup_screen/sign_in_screen.dart';
import 'package:riolive/screens/auth/signup_screen/verifyscreen/verification_screeen.dart';
import 'package:riolive/screens/homescreenbottomnaviagtionbar/homescreenbottomnaviagtionbar.dart';
import 'package:riolive/screens/splashscreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rio Live App',
      debugShowCheckedModeBanner: false,
      home:HomeScreenBottomNaviagtionBar(),
    );
  }
}


