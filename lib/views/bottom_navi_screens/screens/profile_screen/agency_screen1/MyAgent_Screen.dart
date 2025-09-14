import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/agencymanagement_tabs_screens.dart';

import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../about_riolive_screen/AgencyManagementscreen/Agency_Management_Screen.dart';

class MyAgentScreen extends StatelessWidget {
  const MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            RioliveAppBar(title: 'My Agent',),
            const SizedBox(height: 20),

            // Profile image
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/maprofle.png"),
            ),
            const SizedBox(height: 20),

            // Agency title
            const CustomText(
              "Rio Agency",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: CustomText(
                "You have already become a member of the [Rio Agency]."
                    "Please contact official customer service or the agency leader"
                    "if you have any problems",
                fontSize: 16,
                textAlign: TextAlign.center,
                color: Colors.black54,
                softWrap: true,
                fontWeight: FontWeight.w400,
                maxLines: 4,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 First Gradient Container
            Container(
              height: 100,
               width: 383,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8EC2FB), Color(0xFFE496FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Left text
                    Column(
                      children: [
                        CustomText(
                          "Agent RioLive ID",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(height: 5),
                      Row(children: [
                        CustomText(
                          "ID: 3236586",
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.copy, color: Colors.black, size: 15),
                      ],)
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Second Gradient Container
            Container(
              height: 100,
              width: 383,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE496FF), Color(0xFF8EC2FB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Left text
                    Column(
                      children: [
                        CustomText(
                          "Agent WhatsApp",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(height: 5),
                      Row(children: [
                        CustomText(
                          "+91 32365865",
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.copy, color: Colors.black, size: 15),
                      ],)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Custom Gradient Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomGradientButton(
                text: "Continue",
                width: 150,
                height: 52,
                onPressed: () {
                  Get.to(()=> AgencyTabsEasy());
                },
                borderRadius: 30,
                textColor: Colors.black,
                 fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
