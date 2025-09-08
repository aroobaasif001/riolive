import 'dart:convert';

import 'package:flutter/foundation.dart';              // <-- add this
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';   // <-- add this
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:riolive/services/socket_service.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/bottom_navi_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/messages_screen/event_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/invite_screens/invitefriends_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/invite_screens/invitehost_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/live_data_screens/live_broadcast_data_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/reward_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/shop_screens/frame_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/shop_screens/shop_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/exhange_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/grab_orders1_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/my_order_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/wallet_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/withdraw_screen.dart';
import 'package:riolive/views/splashscreen/splash_screen.dart';

import 'controller/signin_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(SocketService());

  // 👇 Wrap your app with DevicePreview
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rio Live App',
      debugShowCheckedModeBanner: false,

      // 🔑 DevicePreview integration
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // NOTE: app flow choose karein:
      // 1) Login flow ke saath (recommended):
      // home: const AppStartup(),
      //
      // 2) Ya seedha MyOrderScreen preview/test:
      home: BottomNaviScreen(),
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
        AppUrl.riolive_id = response['user']['riolive_id'];
        AppUrl.token = token;
        AppUrl.email = response['user']['email'];
        AppUrl.user_name = response['user']['username'];
        AppUrl.user_role = response['user']['role'] ?? 'user';

        debugPrint("🔄 Stay login successful - Role: ${AppUrl.user_role}");

        // init socket after token/userId
        final socketSvc = SocketService.to;
        socketSvc.disposeSocket();
        socketSvc.initSocket(
          AppUrl.token,
          AppUrl.riolive_id.toString(),
        );

        Get.offAll(() => const BottomNaviScreen());
      } else {
        Get.offAll(() => const SplashScreen());
      }
    } catch (e) {
      if (!mounted) return;
      Get.offAll(() => const SplashScreen());
    }
  }

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
