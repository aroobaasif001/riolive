import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class MomentMessageScreen extends StatelessWidget {
  const MomentMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        image: DecorationImage(image: AssetImage('assets/images/m&mBackground.png'), fit: BoxFit.fill),
      ),
    );
  }
}
