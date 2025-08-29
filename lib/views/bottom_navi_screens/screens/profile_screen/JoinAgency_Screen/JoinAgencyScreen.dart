import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import '../../../../../customwidgets/customtext.dart';
import '../about_riolive_screen/about_screen.dart';
import '../verification_screen/redirected_screens/bind_screen.dart' hide CustomText;
import 'MyAgentScreen.dart';

class JoinAgencyScreen extends StatelessWidget {
  const JoinAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: "Join Agency"),
      body: const CustomBackground(
        child: JoinAgencyBody(),
      ),
    );
  }
}

class JoinAgencyBody extends StatelessWidget {
  const JoinAgencyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // 🔹 Box with background image
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/girl_imag2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: const [
              CustomText("Plz add agency ID",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              CustomTextField(
                hintText: "Enter Agency ID",
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: CustomText("Plz input agency ID if you have no agent, plz input ID: 1236456",
            fontSize: 12,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 30),

        // 🔹 Custom Gradient Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: CustomGradientButton(
            text: "Join",
            width: 180,
            height: 52,
            onPressed: () {
              Get.to(()=> MyAgentScreen());
            },
          ),
        ),
      ],
    );
  }
}
