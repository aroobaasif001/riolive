import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utile/app_url.dart';
import '../views/auth/signup_screen/verifyscreen/verification_screeen.dart';
import '../views/auth/password_screen/password_screen.dart';
import '../views/auth/personal_info_screen/personal_info_screen.dart';
import '../views/bottom_navi_screens/bottom_navi_screen.dart';

class SignUpController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController invitationNumber = TextEditingController();

  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isOtpLoading = false.obs;
  RxString selectedGender = ''.obs;
  RxString profileImagePath = ''.obs;

  // Send OTP to email
  Future<void> sendOtp() async {
    if (email.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your email address';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await http.post(
        Uri.parse(AppUrl.getOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text.trim(),
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'OTP sent to your email!');
        Get.to(() => const VerificationScreeen());
      } else if (res.statusCode == 409) {
        errorMessage.value = 'Email already exists! Please try logging in.';
      } else if (res.statusCode == 400) {
        errorMessage.value = 'Invalid email format. Please check and try again.';
      } else {
        errorMessage.value = 'Failed to send OTP. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (otp.text.trim().isEmpty) {
      errorMessage.value = 'Please enter the OTP';
      return;
    }
    if (otp.text.trim().length != 4) {
      errorMessage.value = 'Please enter a valid 4-digit OTP';
      return;
    }

    try {
      isOtpLoading.value = true;
      errorMessage.value = '';

      final res = await http.post(
        Uri.parse(AppUrl.verifyOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text.trim(),
          'otp': otp.text.trim(),
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar('Success', 'OTP verified successfully!');
        // Navigate to password screen
        Get.to(() => const PasswordScreen());
      } else if (res.statusCode == 400) {
        errorMessage.value = 'Invalid or expired OTP. Please try again.';
      } else {
        errorMessage.value = 'Failed to verify OTP. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isOtpLoading.value = false;
    }
  }

  // Complete signup with password (Step 1: Password)
  Future<void> signUp() async {
    if (password.text.trim().isEmpty) {
      errorMessage.value = 'Please enter a password';
      return;
    }
    if (confirmPassword.text.trim().isEmpty) {
      errorMessage.value = 'Please confirm your password';
      return;
    }
    if (password.text != confirmPassword.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      Get.snackbar('Success', 'Password set successfully!');
      // Navigate to personal info screen
      Get.to(() => const PersonalInfoScreen());
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Gender selection method
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Complete registration with personal info (Final Step)
  Future<void> completeSignup() async {
    if (username.text.trim().isEmpty) {
      errorMessage.value = 'Please enter your username';
      return;
    }
    if (age.text.trim().isEmpty) {
      errorMessage.value = 'Please select your age';
      return;
    }
    if (selectedGender.value.isEmpty) {
      errorMessage.value = 'Please select your gender';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await http.post(
        Uri.parse(AppUrl.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.text.trim(),
          'password': password.text,
          'username': username.text.trim(),
          'age': int.tryParse(age.text.trim()) ?? 18,
          'gender': selectedGender.value,
        }),
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        AppUrl.riolive_id = data['user']['riolive_id'];
        AppUrl.user_name = data['user']['username'];
        AppUrl.email = data['user']['email'];
        AppUrl.token = data['token'];

        Get.snackbar('Success', 'Account created successfully!');
        // Navigate to bottom navigation screen (main app)
        Get.offAll(() => const BottomNaviScreen());
      } else if (res.statusCode == 400) {
        final data = jsonDecode(res.body);
        errorMessage.value = data['message'] ?? 'Please verify OTP first';
      } else if (res.statusCode == 409) {
        errorMessage.value = 'Email already exists! Please try logging in.';
      } else {
        errorMessage.value = 'Failed to create account. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    await sendOtp();
  }
}

