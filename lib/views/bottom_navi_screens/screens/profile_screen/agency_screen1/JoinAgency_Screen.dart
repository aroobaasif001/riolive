import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'MyAgent_Screen.dart';

class JoinAgencyScreen extends StatelessWidget {
  const JoinAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg11.png"),
            fit: BoxFit.cover,
          ),
        ),

        // ✅ AppBar top pe (Scaffold appBar ke bina)
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RioliveAppBar(title: 'Join Agency'),

              // ✅ baqi content center me
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        "Plz add agency ID",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 230,
                        height: 64,
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                fontSize: 10, color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const CustomText(
                        "Plz input agency ID if you have no agent, plz input ID: 123456",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // 🔹 Join button (as-is)
                      CustomGradientButton(text: 'Join', onPressed: () {
                        Get.to(()=>MyAgentScreen());

                      },height: 52,width: 180,borderRadius: 30,textColor: Colors.black,fontWeight: FontWeight.w500,fontSize: 16,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
