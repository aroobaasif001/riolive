import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/views/splashscreen/splash_screen.dart';

import '../../../utile/app_url.dart';

class SignUpController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Reactive for error messages
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs; // To track loading state

  Future<void> signUp() async {
    try {
      isLoading.value = true; // Set loading to true when the request starts

      final response = await http.post(
        Uri.parse(AppUrl.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.text, 'password': password.text}),
      );

      if (response.statusCode == 201) {
        // If the response is 201, the user is successfully added
        Get.snackbar('Success', 'User added successfully!');
        // Navigate to SplashScreen or any next screen
        Get.to(() => SplashScreen());
      } else if (response.statusCode == 409) {
        // If email already exists
        errorMessage.value =
            'Email already exists! Please try again with a different email.';
      } else if (response.statusCode == 400) {
        // If bad request, invalid input (e.g., empty fields)
        errorMessage.value =
            'Invalid input. Please check your details and try again.';
      } else if (response.statusCode == 500) {
        // Server error
        errorMessage.value = 'Server error. Please try again later.';
      } else {
        // Handle other unexpected status codes
        errorMessage.value = 'Failed to sign up. Please try again.';
      }
    } catch (e) {
      // Catch any errors that occur during the request
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false; // Set loading to false when the request ends
    }
  }
}
