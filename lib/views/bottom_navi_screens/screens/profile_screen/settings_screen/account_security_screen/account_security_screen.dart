import 'package:flutter/material.dart';

// apne exact paths se replace karein
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart'; // RioliveAppBar

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final _line = Colors.black.withOpacity(0.08);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // ---- FULL SCREEN BACKGROUND ----
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg11.png',
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
                  child: RioliveAppBar(title: 'Account and security'),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero, // edge-to-edge containers
                    child: Column(
                      children: [
                        const SizedBox(height: 1),

                        // Shield + description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/shield9.png', // <- apna path
                                width: 72,
                                height: 150,
                              ),
                              const SizedBox(height: 1),
                              const CustomText(
                                softWrap: true,
                                maxLines: 3,
                                'Lorem Ipsum is simply dummy text of the\n printing Lorem Ipsum.',
                                style: TextStyle(fontSize: 10, height: 1.35),
                                color: Color(0xFFE44B4B), // red like mock
                                textAlign: TextAlign.center,
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== GROUP 1: Set Password + Phone number (edge-to-edge) =====
                        CustomContainer(
                          width: double.infinity,
                          conColor: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          // no horizontal margin -> starts from screen edges
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // Set Password
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Set Password',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.chevron_right,
                                          color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: _line),

                              // Phone number (Bind on right)
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: CustomText(
                                          'Phone number',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          color: Colors.black,
                                        ),
                                      ),
                                      CustomText(
                                        'Bind',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                        color: Colors.black45,
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.chevron_right,
                                          color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: _line),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== GROUP 2: Email address (edge-to-edge) =====
                        CustomContainer(
                          width: double.infinity,
                          conColor: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        'Email address',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        color: Colors.black,
                                      ),
                                    ),
                                    CustomText(
                                      'Bind',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      color: Colors.black45,
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.chevron_right,
                                        color: Colors.black54),
                                  ],
                                ),
                              ),
                              // divider under single row:
                              // ignore if you don't want a line here
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),



                // ===== BOTTOM: Delete account button (center, narrow) =====
                SafeArea(
                  top: false,
                  child: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(16, 8, 16, 20), // outer gap
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: delete account action
                        },
                        child: CustomContainer(
                          width:
                          MediaQuery.of(context).size.width * 0.65, // centered narrow
                          height: 46,
                          conColor: const Color(0xFFBFB8C0).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(18),
                          alignment: Alignment.center,
                          child: const CustomText(
                            'Delete  account',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            color: Color(0xFFE24B50),
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
