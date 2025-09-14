import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../showInviteHostSheet.dart';
class TopMineScreen extends StatelessWidget {
  const TopMineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          CustomContainer(
            conColor: const Color(0xffEFD8D8),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CustomText(
                                "Alexander",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(width: 4),
                              Image(image: AssetImage('assets/images/agency....png'),height: 19,width: 50,), // thoda chhota
                              const SizedBox(width: 4),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const CustomText(
                                "ID: 10209804",
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    const ClipboardData(
                                        text: "10209804"),
                                  );
                                  Get.snackbar("Copied",
                                      "ID copied to clipboard");
                                },
                                child: const Icon(
                                  Icons.copy,
                                  color: Colors.black54,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        'Agency Code:   2XD56C',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            const ClipboardData(text: "2XD56C"),
                          );
                          Get.snackbar("Copied",
                              "Agency code copied to clipboard");
                        },
                        child: const Icon(
                          Icons.copy,
                          color: Colors.black54,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/supporticon.png",
                      width: 27,
                      height: 22,
                    ),
                    const SizedBox(width: 10),
                    const CustomText(
                      "Support",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: CustomContainer(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xffE0F7E9),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/rio2.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const CustomText(
                      "Rio",
                      fontSize: 14,
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
                const SizedBox(height: 1),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/bar_chart.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    const CustomText(
                      "My Agency Level",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    const CustomText(
                      "C:10%",
                      fontSize: 14,
                      color: Colors.black87,
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

          const SizedBox(height: 15),
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
                  "Invite Host",
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
                      CustomContainer(
                        height: 38,
                        width: 97,
                        conColor: Color(0xff8EF797),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Image(image: AssetImage('assets/icons/Bell_Notification_24.png'),height: 22,width: 16,),
                          CustomText('Application',fontWeight: FontWeight.w500,fontSize: 9,)
                        ],),
                      )
                    ],

                  ),
                ),
              ],
            ),
          ),

        ],),
      ),
    );
  }
}
