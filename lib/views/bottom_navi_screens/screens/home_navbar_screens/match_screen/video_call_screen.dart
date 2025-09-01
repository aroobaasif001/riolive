import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'host_screen.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  String statusText = "Connecting"; // Initial status

  @override
  void initState() {
    super.initState();

    // ⏳ After 5 seconds → change to Connected
    Timer(const Duration(seconds: 5), () {
      setState(() {
        statusText = "Connected";
      });

      // ⏳ After 2 more seconds → navigate to next screen
      Timer(const Duration(seconds: 2), () {
        Get.to(() => const HostScreen());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        width: double.infinity,
        image: const DecorationImage(image: AssetImage('assets/images/Video Call.png'), fit: BoxFit.fill),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Title
            CustomText(
              'Random Video Call',
              color: const Color(0xff7D7D7D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 140),

            // 🔹 Profile images with heart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  width: 84,
                  height: 84,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 3),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/girl_img3.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 10),
                const Image(image: AssetImage('assets/icons/Two Hearts.png'), height: 68, width: 68),
                const SizedBox(width: 10),
                CustomContainer(
                  width: 84,
                  height: 84,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 3),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/girl_img3.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 65),

            // 🔹 Status Text (Matching → Connected)
            CustomText("Matching", fontSize: 24, fontWeight: FontWeight.w600),
            const SizedBox(height: 63),

            CustomText(
              statusText,
              color: statusText == "Connected" ? Colors.green : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 72),

            // 🔹 End call button
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              padding: const EdgeInsets.all(18),
              child: const Icon(Icons.call_end, size: 32, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
