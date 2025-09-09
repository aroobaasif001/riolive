import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';

void Exitagencyshowdialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 345,
              height: 330,
              child: CustomContainer(
                conColor: const Color(0xFFCAF2B9),
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    // 🔥 max so Spacer kaam kare aur button neeche chipak jaye
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CustomText(
                        "ALI",
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 12),

                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage("assets/images/profile.png"),
                      ),

                      const SizedBox(height: 12),
                      const CustomText(
                        "Rio",
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),

                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(width: 8),
                          CustomText("ID: 10207604", fontSize: 14, color: Colors.black),
                          SizedBox(width: 6),
                          Icon(Icons.copy, size: 16, color: Colors.black54),
                        ],

                      ),
                      const CustomText("+44 54546789", fontSize: 14, color: Colors.black),
                      const SizedBox(width: 6),
                      const Icon(Icons.copy, size: 16, color: Colors.black54),

                      const SizedBox(height: 12),

                      // ⬇️ Push remaining space so button stays at bottom
                      const Spacer(),

                      // ===== Bottom-center Gradient Button =====
                      GestureDetector(
                        onTap: () {
                          // TODO: yahan apni action lagao (e.g. exit API call)
                          Get.back(); // dialog band
                        },
                        child: Container(
                          width: 150,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF8EC2FB),
                                Color(0xFFE496FF),
                                Color(0xFF32B4FF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: CustomText(
                              'Remove',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
