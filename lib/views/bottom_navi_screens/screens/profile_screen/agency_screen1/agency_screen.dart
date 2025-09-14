import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../become_a_agent_screen/becomeags_creats.dart';
import 'JoinAgency_Screen.dart';

class AgencyScreen extends StatelessWidget {
  const AgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ==== Simple responsive helpers (MediaQuery based) ====
    final size = MediaQuery.of(context).size;
    const baseW = 390.0; // your design width
    const baseH = 844.0; // your design height
    final wScale = size.width / baseW;
    final hScale = size.height / baseH;
    final k = math.min(wScale, hScale); // balanced scale for fonts/radius

    double w(num v) => v * wScale; // width-based values
    double h(num v) => v * hScale; // height-based values
    double sp(num v) => v * k;     // font sizes, radii, icons

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
        child: Column(
          children: [
            RioliveAppBar(title: 'Agency'),
            // Expanded gives the scroll view proper height on all screens
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: h(50), left: w(29), right: w(29)),
                child: Column(
                  children: [
                    // 1️⃣ Become a agent
                    CustomContainer(
                      height: h(160),
                      width: w(300),
                      borderRadius: BorderRadius.circular(sp(20)),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/agency1.png"),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icone1.png",
                            height: sp(40),
                            width: sp(40),
                          ),
                          SizedBox(height: h(41)),
                          SizedBox(
                            width: w(200),
                            height: h(50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(sp(12)),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Get.to(() => CreateAgencyScreen());
                              },
                              child: CustomText(
                                "Become a agent",
                                fontSize: sp(14),
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h(41)),

                    // 2️⃣ Join Agency
                    CustomContainer
                      (
                      height: h(160),
                      width: w(300),
                      borderRadius: BorderRadius.circular(sp(20)),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/agency2.png"),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icone1.png",
                            height: sp(40),
                            width: sp(40),
                          ),
                          SizedBox(height: h(10)),
                          SizedBox(
                            width: w(200),
                            height: h(50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(sp(12)),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Get.to(() => const JoinAgencyScreen());
                              },
                              child: CustomText(
                                "Join Agency",
                                fontSize: sp(14),
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h(41)),

                    // 3️⃣ Become a coin seller
                    CustomContainer(
                      height: h(160),
                      width: w(300),
                      borderRadius: BorderRadius.circular(sp(20)),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/agency3.png"),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icone1.png",
                            height: sp(40),
                            width: sp(40),
                          ),
                          SizedBox(height: h(10)),
                          SizedBox(
                            width: w(200),
                            height: h(50),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(sp(12)),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {},
                              child: CustomText(
                                "Become a coin seller",
                                fontSize: sp(14),
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
