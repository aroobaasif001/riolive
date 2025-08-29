import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utile/app_url.dart';
import '../views/splashscreen/splash_screen.dart';

class SignUpController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> signUp() async {
    try {
      isLoading.value = true;

      final res = await http.post(
        Uri.parse(AppUrl.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text.trim(),
          'password': password.text,
        }),
      );

      // First handle status code
      if (res.statusCode == 201) {
        // Parse JSON only on success
        try {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          AppUrl.riolive_id = data['user']['riolive_id'];
          print(AppUrl.riolive_id);
        } catch (_) {
          // parsing failure shouldn't block OTP send
        }

        // 👉 Send OTP now (POST with email in body)
        final otpOk = await _sendOtp(email.text.trim());

        if (otpOk) {
          Get.snackbar('Success', 'User created & OTP sent to your email!');
        } else {
          Get.snackbar(
            'Warning',
            'Account created but OTP could not be sent. Try again from “Resend OTP”.',
          );
        }

        // Navigate next (Splash/OTP screen as per your flow)
        Get.to(() => SplashScreen());
      } else if (res.statusCode == 409) {
        errorMessage.value =
            'Email already exists! Please try again with a different email.';
      } else if (res.statusCode == 400) {
        errorMessage.value =
            'Invalid input. Please check your details and try again.';
      } else if (res.statusCode == 500) {
        errorMessage.value = 'Server error. Please try again later.';
      } else {
        errorMessage.value = 'Failed to sign up. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ---- Helper: POST /get-code with email in body ----
  Future<bool> _sendOtp(String email) async {
    try {
      final r = await http.post(
        Uri.parse(AppUrl.sendOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'riolive_id': AppUrl.riolive_id, 'email': email}),
      );

      print(r.body);
      // consider any 2xx as success
      return r.statusCode >= 200 && r.statusCode < 300;
    } catch (e) {
      debugPrint('sendOTP error: $e');
      return false;
    }
  }
}
