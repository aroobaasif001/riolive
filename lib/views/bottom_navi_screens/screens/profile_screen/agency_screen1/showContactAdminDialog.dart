import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';

void showContactAdminDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) {
      return Align( // ⬅️ bottom par laane ke liye
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24), // thoda bottom gap
          child: Material(
            color: Colors.transparent,
            child: SizedBox( // ⬅️ fixed size
              width: 345,
              height: 330,
              child: CustomContainer(
                conColor: const Color(0xFFCAF2B9),
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomText(
                        "Need help? contact Admin",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 12),

                      // avatar
                     CustomContainer(
                       height: 71,
                       width: 72,
                       shape: BoxShape.circle,
                       child: Image(image: AssetImage('assets/images/pro.png')),
                     ),
                      const SizedBox(height: 12),
                      const CustomText(
                        "Rio Live",
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),

                      const SizedBox(height: 8),
                      // WhatsApp + number + copy
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          const CustomText("+44 54546789",
                              fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500,),
                          const SizedBox(width: 6),
                          const Icon(Icons.copy, size: 16, color: Colors.black),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // chat badge
                      CustomContainer(
                        height: 45,
                        width: 50,
                        padding: EdgeInsets.all(5),
                        conColor: const Color(0xFFCDC4C3),
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/icons/chat25.png",
                          width: 28,
                          height: 22,
                        ),
                      ),

                      const SizedBox(height: 10),
                      const CustomText(
                        "Official Live Support",
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontType: AppFont.poppins,
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
