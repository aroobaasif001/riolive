import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/socket/incoming_calls.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/bottom_navi_screen.dart';
import 'package:riolive/views/splashscreen/splash_screen.dart';

import 'controller/signin_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // IMPORTANT
  Get.put(SocketService()); // register SocketService globally
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rio Live App',
      debugShowCheckedModeBanner: false,
      home: const AppStartup(),
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late final SignInController _signInController;

  @override
  void initState() {
    super.initState();
    _signInController = Get.put(SignInController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStayLoggedIn();
    });
  }

  Future<void> _checkStayLoggedIn() async {
    try {
      final token = await _signInController.getToken();

      // Case 1: No token → Splash
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        Get.offAll(() => const SplashScreen());
        return;
      }

      // Case 2: Token exists → verify with API
      final response = await _stayLogin(token);
      if (!mounted) return;

      final ok = response['status'] == 'success' && response['user'] != null;
      if (ok) {
        // Save user details globally
        AppUrl.riolive_id = response['user']['riolive_id'];
        AppUrl.token = token;
        AppUrl.email = response['user']['email'];
        AppUrl.user_name = response['user']['username'];

        // 🔌 Initialize socket **now** (AFTER we know token & userId)
        final socketSvc = SocketService.to;
        socketSvc.disposeSocket(); // safety: drop any stale connection
        socketSvc.initSocket(
          AppUrl.token,
          AppUrl.riolive_id.toString(), // userId must be string
        );

        // Go to home
        Get.offAll(() => const BottomNaviScreen());
      } else {
        Get.offAll(() => const SplashScreen());
      }
    } catch (e) {
      if (!mounted) return;
      Get.offAll(() => const SplashScreen());
    }
  }

  // stayLogin API request (GET request)
  Future<Map<String, dynamic>> _stayLogin(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.stayLogin),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'status': 'failure'};
    } catch (e) {
      return {'status': 'failure', 'message': e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
