import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../controller/become_a_agent_controller.dart';
import '../../../../../customwidgets/custombutton.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/customtextformfield.dart';

class CreateAgencyScreen extends StatelessWidget {
  const CreateAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAgencyController()); // 👈 Controller bind
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Add listener for verification code checking
    controller.verificationCodeController.addListener(() {
      controller.checkCode(controller.verificationCodeController.text);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const CustomText(
          "Create an Agency",
          fontType: AppFont.poppins,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6FB), Color(0xFFF9EDFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RioLive Id
                const CustomText(
                  "*Your RioLive id",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "ID Number",
                  width: double.infinity,
                  controller: controller.rioliveIdController,
                ),
                const SizedBox(height: 18),

                // Verification Code
                const CustomText(
                  "RioLive Verification Code",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "Verification Code",
                        width: double.infinity,
                        controller: controller.verificationCodeController,
                        suffix: controller.isCodeVerified.value
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: controller.isLoading.value ? "..." : "Get",
                      height: 50,
                      width: 90,
                      textColor: Colors.white,
                      backgroundColor: const Color(0xffC45CFF).withOpacity(0.9),
                      onPressed: () => controller.getVerificationCode(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Country
                const CustomText(
                  "Country",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "Please enter Country",
                  width: double.infinity,
                  controller: controller.countryController,
                  suffix: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 18),

                // Description
                const CustomText(
                  "Description",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "Please Add",
                  width: double.infinity,
                  controller: controller.descriptionController,
                ),
                const SizedBox(height: 18),

                // WhatsApp
                const CustomText(
                  "WhatsApp",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "Please fill in whatsApp with country code",
                  width: double.infinity,
                  controller: controller.whatsappController,
                  suffix: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 18),

                // Experience
                const CustomText(
                  "Experience",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: controller.experience.value,
                      onChanged: (val) => controller.experience.value = val!,
                    ),
                    const CustomText(
                      "Yes",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 15),
                    Radio<bool>(
                      value: false,
                      groupValue: controller.experience.value,
                      onChanged: (val) => controller.experience.value = val!,
                    ),
                    const CustomText(
                      "No",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Other Platforms + Proof
                if (controller.experience.value) ...[
                  const CustomText(
                    "Name of other Platforms:",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    hintText: "Please enter",
                    width: double.infinity,
                    controller: controller.platformController,
                  ),
                  const SizedBox(height: 18),

                  // Proof
                  const CustomText(
                    "Proof of cooperation:(optional)",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        controller.proofFile.value = File(picked.path);
                      }
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.proofFile.value == null
                          ? const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : Image.file(
                              controller.proofFile.value!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                // Apply Button
                Center(
                  child: CustomButton(
                    text: "Apply",
                    width: screenWidth * 0.6,
                    height: 55,
                    textColor: Colors.white,
                    backgroundColor: const Color(0xffC45CFF).withOpacity(0.9),
                    onPressed: () => controller.applyAgency(),
                  ),
                ),
                const SizedBox(height: 30),

                // Warm Tips
                const CustomText(
                  "Warm Tips :",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                const CustomText(
                  maxLines: 15,
                  "1. Plz invite 5 valid hosts at least within a month after registration.\n"
                  "2. Valid host: Live for over 2 hours daily at least on one day within a week.\n"
                  "3. If active valid hosts is less than 5 in a month, platform holds the right to take follow-up action to the agency.",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  lineHeight: 1.5,
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
