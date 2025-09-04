import 'package:flutter/material.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../../../../../customwidgets/CustomInputField.dart';

void showInviteHostSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) {
      final idCtrl = TextEditingController();
      final w = MediaQuery.of(context).size.width;

      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: w > 360 ? 345 : w - 24, // image-like width
              child: CustomContainer(
                conColor: const Color(0xFFCFF6BF), // light mint bg
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText("Invite Host",
                        fontSize: 16, fontWeight: FontWeight.w700),
                    const SizedBox(height: 12),

                    // 🔎 Search User ID
                    CustomInputField(
                      controller: idCtrl,
                      hintText: "Search User ID",
                      prefixIcon: Icons.search, // if supported by your widget
                    ),

                    const SizedBox(height: 16),
                    const CustomText("Share To",
                        fontSize: 13, color: Colors.black54),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Copy Link
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {}, // TODO
                              child: CustomContainer(

                                borderRadius: BorderRadius.circular(28),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/icons/link.png",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CustomText("Copy Link",
                                fontSize: 11, color: Colors.black54),
                          ],
                        ),

                        // Image Sharing
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {}, // TODO
                              child: CustomContainer(

                                borderRadius: BorderRadius.circular(28),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/icons/image_share.png",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CustomText("Image Sharing",
                                fontSize: 11, color: Colors.black54),
                          ],
                        ),

                        // WhatsApp
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {}, // TODO
                              child: CustomContainer(

                                borderRadius: BorderRadius.circular(28),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/icons/image_share.png",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CustomText("WhatsApp",
                                fontSize: 11, color: Colors.black54),
                          ],
                        ),

                        // Facebook
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {}, // TODO
                              child: CustomContainer(
                                borderRadius: BorderRadius.circular(28),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/icons/image_share.png",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CustomText("Facbook",
                                fontSize: 11, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
