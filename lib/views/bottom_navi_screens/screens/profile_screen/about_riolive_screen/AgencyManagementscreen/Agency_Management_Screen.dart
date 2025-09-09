import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/showContactAdminDialog.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/agency_screen1/showInviteHostSheet.dart';
import '../../../../../../../customwidgets/custom_container.dart';
import '../../../../../../../customwidgets/customtext.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import 'AgencyManagementV2.dart';
import 'MIne_screen.dart';
import 'Sub_agency/Sub_agency.dart';
class AgencyManagementScreen extends StatelessWidget {
  const AgencyManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          "Agency Management",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg11.png'), // your bg image
            fit: BoxFit.cover, // full screen cover
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                conColor: const Color(0xffCDF2CB),
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 🔥 reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage("assets/images/profile.png"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CustomText(
                                    "Alexander",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.copy,
                                      color: Colors.black54, size: 14), // thoda chhota
                                  const SizedBox(width: 4),
                                  CustomContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const CustomText(
                                      "Agency",
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const CustomText(
                                "ID: 10209804",
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5), // spacing kam
                    const Divider(),
                    Row(
                      children: [
                        // 👨‍💻 Support agent image
                        Image.asset(
                          "assets/icons/supporticon.png",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        const CustomText(
                          "Support",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => showContactAdminDialog(context),
                          child: CustomContainer(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xffE0F7E9),
                            shape: BoxShape.circle,
                          ),


                          child: Image.asset(
                            "assets/icons/chat25.png",
                            width: 18,
                            height: 18,
                          ),
                        ),
                        ),
                         SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/bar_chart.png", // apna bar chart icon yahan lagao
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        const CustomText(
                          "My Agency Level",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        const CustomText(
                          "A:16%",
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              CustomContainer
                (
                conColor: const Color(0xffE9F5FF), // light blue panel bg
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      "Invite Creator & Agency",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const CustomText("Number of Host", fontSize: 11),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                        const Spacer(),
                        // Orange gradient pill
                        CustomGradientButton(
                          text: "Invite Host",
                          width: 100,
                          height: 30,
                          borderRadius: 24,
                          gradientColors: const [Color(0xffFE7E07), Color(0xffFFDE67)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          textColor: Colors.black,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          onPressed: () => showInviteHostSheet(context),
                        )

                      ],
                    ),
                    const SizedBox(height: 0.1),
                    Row(
                      children: [
                        const CustomText("Number of Sub agent", fontSize: 11),
                        const SizedBox(width: 3),
                        const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                        const Spacer(),
                        // Green gradient pill
                        CustomGradientButton(
                          text: "Invite Agency",
                          width: 100,
                          height: 30,
                          borderRadius: 24,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          gradientColors: [Color(0xff11876B), Color(0xffB0FF4B)],
                          textColor: Colors.black,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText("SUMMARY",
                      fontWeight: FontWeight.bold, color: Colors.black),

                  InkWell(
                    onTap: () {
                      Get.to(() => const AgencyManagementV2());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: CustomText("Host", color: Colors.grey),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.to(() => const SubAgency());

                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: CustomText("Sub AGENCY", color: Colors.grey),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.to(() => const MineScreen());
                      // TODO: MINE pressed action
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: CustomText("MINE", color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              CustomContainer(
                conColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CustomText("Total Bonus:", fontSize: 14, fontWeight: FontWeight.bold),
                            const SizedBox(width: 6),
                            const Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                            const SizedBox(width: 2),
                            const CustomText("0", fontSize: 14, fontWeight: FontWeight.bold),
                            const SizedBox(width: 6),
                            // small help badge
                            CustomContainer(
                              conColor: const Color(0xFFEFEFEF),
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(Icons.help_outline, size: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            CustomText("Details", fontSize: 12, color: Colors.black54),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 16, color: Colors.black54),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 14),
                    CustomContainer(
                      conColor: const Color(0xFFFFF3DB), // soft cream
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CustomText("Reward 1",
                                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFE26A00)),
                              const SizedBox(width: 8),
                              const CustomText("Host Commission",
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                              const Spacer(),
                              CustomContainer(
                                conColor: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.arrow_circle_right_outlined, size: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const CustomText("Commission", fontSize: 12, color: Colors.black87),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  CustomText("6%", fontSize: 14, fontWeight: FontWeight.bold),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                                      SizedBox(width: 4),
                                      CustomText("0", fontSize: 12, color: Colors.black54),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomContainer(
                      conColor: const Color(0xFFE8F3FF), // soft blue
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CustomText("Reward 2",
                                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D79C7)),
                              const SizedBox(width: 8),
                              const CustomText("Agent Commission",
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                              const Spacer(),
                              CustomContainer(
                                conColor: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.arrow_circle_right_outlined, size: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const CustomText("Commission", fontSize: 12, color: Colors.black87),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  CustomText("6%", fontSize: 14, fontWeight: FontWeight.bold),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                                      SizedBox(width: 4),
                                      CustomText("0", fontSize: 12, color: Colors.black54),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomContainer(
                      conColor: const Color(0xFFFFE2E6), // soft pink
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              CustomText("Reward",
                                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFBF4C4C)),
                              Spacer(),
                              CustomText("Total Commission",
                                  fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A6FB8)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomContainer(
                            conColor: const Color(0xFFFFCDD4), // darker pink strip
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: const [
                                Icon(Icons.monetization_on, color: Colors.orange, size: 20),
                                SizedBox(width: 8),
                                CustomText("Earned", fontSize: 12, color: Colors.black87),
                                Spacer(),
                                CustomText("1,917.32",
                                    fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
                ),
              ),
          ),
    );
  }
}
