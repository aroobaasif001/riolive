import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/views/auth/signup_screen/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utile/app_url.dart';
import '../views/bottom_navi_screens/bottom_navi_screen.dart';

class SignInController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  RxBool isLoading = false.obs; // To track loading state
  RxString errorMessage = ''.obs;

  // get http => null; // For displaying error messages
  Future<void> signIn() async {
    try {
      isLoading.value = true; // Set loading to true when request starts

      final response = await http.post(
        Uri.parse(AppUrl.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.text, 'password': password.text}),
      );

      if (response.statusCode == 200) {
        // If login is successful, parse the response
        final data = jsonDecode(response.body);
        final token = data['token']; // Extract token from response
        AppUrl.riolive_id = data['user']['riolive_id'];
        AppUrl.user_name = data['user']['username'];

        // Save the token in SharedPreferences
        _saveToken(token);
        AppUrl.token = token;

        print(response.statusCode);

        Get.snackbar('Success', 'Login successful!');
        Get.offAll(() => BottomNaviScreen()); // Navigate to the home screen
      } else {
        print(response.statusCode);
        errorMessage.value = 'Failed to login. Status: ${response.statusCode}';
        Get.to(() => SignUpScreen());
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false; // Set loading to false when request ends
    }
  }

  // Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Save token
  }

  // Retrieve token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Retrieve token
  }
}
