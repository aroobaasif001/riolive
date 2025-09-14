import 'package:flutter/material.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../showContactAdminDialog.dart';
import '../showInviteHostSheet.dart';
class TopSummaryScreen extends StatelessWidget {
  const TopSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomContainer(
            conColor: const Color(0xffCDF2CB),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ), // 🔥 reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(
                        "assets/images/profile.png",
                      ),
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
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(width: 4),
                              Image(image: AssetImage('assets/images/agency....png'),height: 19,width: 50,), // thoda chhota
                              const SizedBox(width: 4),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(children: [
                            const CustomText(
                              "ID: 10209804",
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 3,),
                            Icon(Icons.copy,size: 10,color: Colors.black,)
                          ],)
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
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
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
          CustomContainer(
            height: 111,
            width: 389,
            conColor: const Color(0xffE9F5FF),
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // ⬅️ 10 → 6
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ⬅️ extra space avoid
              children: [
                const CustomText(
                  "Invite Creator & Agency",
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                Expanded(
                  child: Row(
                    children: [
                      const CustomText("Number of Host", fontSize: 11, fontWeight: FontWeight.w500),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                      const Spacer(),
                      CustomGradientButton(
                        text: "Invite Host",
                        padding: const EdgeInsets.only(bottom: 0),
                        width: 85, height: 23, borderRadius: 24,
                        gradientColors: const [Color(0xffFE7E07), Color(0xffFFDE67)],
                        begin: Alignment.centerLeft, end: Alignment.centerRight,
                        textColor: Colors.black, fontSize: 10, fontWeight: FontWeight.w600,
                        onPressed: () => showInviteHostSheet(context),
                      ),
                    ],
                  ),
                ),
                // ⬅️ rows ke darmiyan gap kam
                Expanded(
                  child: Row(
                    children: [
                      const CustomText("Number of Sub agent", fontSize: 11, fontWeight: FontWeight.w500),
                      const SizedBox(width: 3),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                      const Spacer(),
                      CustomGradientButton(
                        padding: const EdgeInsets.only(bottom: 1),
                        text: "Invite Agency",
                        width: 85, height: 23, borderRadius: 24,
                        begin: Alignment.centerLeft, end: Alignment.centerRight,
                        gradientColors: const [Color(0xff11876B), Color(0xffB0FF4B)],
                        textColor: Colors.black, fontSize: 9.5, fontWeight: FontWeight.w600,
                        onPressed: () {},
                      ),
                    ],

                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
