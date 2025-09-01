import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utile/app_url.dart';

class CreateAgencyController extends GetxController {
  // 🔹 Text controllers
  final rioliveIdController = TextEditingController(text: AppUrl.riolive_id);
  final verificationCodeController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();
  final whatsappController = TextEditingController();
  final platformController = TextEditingController();

  // 🔹 State variables
  var isLoading = false.obs;
  var apiVerificationCode = "".obs;
  var isCodeVerified = false.obs;
  var experience = true.obs; // default Yes
  var proofFile = Rx<File?>(null);

  // 🔹 API token & email
  final String email = AppUrl.email;

  /// Step 1: Get Verification Code API
  Future<void> getVerificationCode() async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(AppUrl.sendOTP),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "riolive_id": rioliveIdController.text.trim(),
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        apiVerificationCode.value = data["verification_code"] ?? "";
        Get.snackbar("Success", "Verification code sent!");
      } else {
        Get.snackbar("Error", "Failed to get code: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: Verify Code Input
  void checkCode(String enteredCode) {
    if (enteredCode.trim() == apiVerificationCode.value.trim()) {
      isCodeVerified.value = true;
    } else {
      isCodeVerified.value = false;
    }
  }

  /// Step 3: Submit Agency Form API
  Future<void> applyAgency() async {
    // if (!isCodeVerified.value) {
    //   Get.snackbar("Error", "Please verify code first!");
    //   return;
    // }

    try {
      isLoading.value = true;

      // 🔹 Multipart Request for optional file upload
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppUrl.createAgency),
      );

      request.headers.addAll({
        "Authorization": "Bearer ${AppUrl.token}",
        "Content-Type": "multipart/form-data",
      });

      // 🔹 Add text fields
      request.fields["riolive_id"] = rioliveIdController.text.trim();
      request.fields["verification_code"] = verificationCodeController.text
          .trim();
      request.fields["country"] = countryController.text.trim();
      request.fields["description"] = descriptionController.text.trim();
      request.fields["whatsapp_number"] = whatsappController.text.trim();
      request.fields["experience"] = experience.value ? "yes" : "no";
      request.fields["email"] = AppUrl.email;

      if (experience.value) {
        request.fields["platform"] = platformController.text.trim();
      }

      // 🔹 Add file if available
      if (proofFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath("proof", proofFile.value!.path),
        );
      }

      // 🔹 Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Agency Created Successfully!");
        Get.back();
      } else {
        Get.snackbar("Error", "Failed to apply: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
