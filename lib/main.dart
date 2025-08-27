import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/views/bottom_navi_screens/bottom_navi_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final app = Firebase.app();
  debugPrint('✅ Connected to Firebase project: ${app.options.projectId}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rio Live App',
      debugShowCheckedModeBanner: false,
      home: BottomNaviScreen(),
    );
  }
}
