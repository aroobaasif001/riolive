import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// === apne exact paths se replace karein ===
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

import 'account_security_screen/account_security_screen.dart'; // e.g. RioliveAppBar

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pipEnabled = true;
  final String _version = '5.2.392.1128';
  final String _cacheSize = '177.95M';

  @override
  Widget build(BuildContext context) {
    final line = Colors.black.withOpacity(0.08);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // ---- FULL SCREEN BACKGROUND ----
            Positioned.fill(
              child: Image.asset(
                'assets/images/Livebroadcastdatabg.jpg', // <-- apna path
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // ---- FOREGROUND ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RioliveAppBar(title: 'Settings'),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // ===== GROUP 1: Account -> Language =====
                        CustomContainer(
                          width: double.infinity,
                          conColor: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Column(
                            children: [
                              // Account and security
                              InkWell(
                                onTap: () {
                                  Get.to(() => const AccountSecurityScreen());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            CustomText(
                                              'Account and security',
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w600),
                                              color: Colors.black,
                                            ),
                                            SizedBox(height: 4),
                                            CustomText(
                                              'Security level: Low',
                                              style: TextStyle(fontSize: 12),
                                              color: Color(0xFFFF6F6F),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),
                              // Security Password
                              InkWell(
                                onTap: () {
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Security Password',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),

                              // Language Setting
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Language Setting',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== GROUP 2: Blacklist (single row) =====
                        CustomContainer(
                          width: double.infinity,
                          conColor: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Blacklist',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== GROUP 3: Out-of-app -> Clear Cache =====
                        CustomContainer(
                          width: double.infinity,
                          conColor: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: [
                              // Out-of-app PiP
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: CustomText(
                                        'Out-of-app Picture-in-Picture',
                                        style: TextStyle(
                                            fontSize: 16,),
                                        color: Colors.black,
                                      ),
                                    ),
                                    Switch(
                                      value: pipEnabled,
                                      onChanged: (v) => setState(() => pipEnabled = v),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 1, color: line),

                              // Version
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: CustomText(
                                          'Version',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      CustomText(
                                        _version,
                                        style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w500),
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),

                              // Rate for Rio
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Rate for Rio',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),
                              InkWell(
                                onTap: () {}, // TODO: clear cache
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: CustomText(
                                          'Clear Cache',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      CustomText(
                                        _cacheSize,
                                        style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w500),
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.chevron_right, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: line),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Center( // <- center the button
                      child: GestureDetector(
                        onTap: () {
                          // TODO: logout action
                        },
                        child: CustomContainer(
                          // narrow & responsive width
                          width: MediaQuery.of(context).size.width * 0.6, // ~60% of screen
                          height: 46,
                          conColor: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(18),
                          alignment: Alignment.center,
                          child: const CustomText(
                            'Log Out',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
