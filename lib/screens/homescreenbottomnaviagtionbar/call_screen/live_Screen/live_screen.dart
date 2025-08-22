import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: 'Allah is one'),

      ],),
    ));
  }
}
