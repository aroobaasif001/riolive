import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/bottom_navi_screen.dart';
import 'package:riolive/views/splashscreen/splash_screen.dart';

import 'controller/signin_controller.dart'; // Import the SignInController

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // <-- IMPORTANT

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rio Live App',
      debugShowCheckedModeBanner: false,
      home:
          const AppStartup(), // Call the AppStartup screen to check login status
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  _AppStartupState createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late SignInController _signInController; // Declare the controller

  @override
  void initState() {
    super.initState();
    _signInController = Get.put(
      SignInController(),
    ); // Initialize SignInController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStayLoggedIn();
    });
  }

  Future<void> _checkStayLoggedIn() async {
    var token = await _signInController
        .getToken(); // Retrieve the token from SharedPreferences
    print("token");
    print(token);
    // token = '';
    if (token != null && token.isNotEmpty) {
      final response = await _stayLogin(token); // Pass token to stayLogin API

      print(response['user']['riolive_id']);
      // setState(() {});
      AppUrl.riolive_id = response['user']['riolive_id'];
      AppUrl.token = token;
      // Log the response for debugging
      final users = response['user'];
      AppUrl.user_name = response['user']['username'];

      // final id = users['riolive_id'];
      print("API Response: $response");
      print(response['status']);
      print(users);

      if (!mounted) return;

      if (response['status'] == 'success') {
        // If login is successful, navigate to the home screen
        Get.offAll(() => const BottomNaviScreen());
      } else {
        if (!mounted) return;

        // If login fails, navigate to the splash screen
        Get.offAll(() => const SplashScreen());
      }
    } else {
      if (!mounted) return;

      // If token is null or empty, navigate to the splash screen
      Get.offAll(() => const SplashScreen());
    }
  }

  // stayLogin API request (POST request)
  Future<Map<String, dynamic>> _stayLogin(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.stayLogin), // stayLogin POST API URL
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // header me token
            },
            // body: jsonEncode({
            //   "token": token
            //       .toString(), // body me bhi bhejna ho sakta hai (depends on API requirement)
            // }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'failure'};
      }
    } catch (e) {
      return {'status': 'failure', 'message': e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show loading while checking the login status
      ),
    );
  }
}
