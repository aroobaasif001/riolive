import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../agency_screen1/showContactAdminDialog.dart';
import '../../agency_screen1/showInviteHostSheet.dart';
import 'Exit_agency_showdialog.dart';
import '../../agency_screen1/HostApplicationScreen.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  String _filter = 'All Creator'; // (kept if you’ll use later)
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final line = Colors.black.withOpacity(.08);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg11.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RioliveAppBar(title: 'Agency Management'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== Top summary card =====
                        CustomContainer(
                          conColor: const Color(0xffEFD8D8),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 26,
                                    backgroundImage: AssetImage(
                                      "assets/images/profile.png",
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const CustomText(
                                              "Alexander",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(width: 4),
                                            CustomContainer(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              child: const CustomText(
                                                "Agency",
                                                fontSize: 11,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const CustomText(
                                              "ID: 10209804",
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(
                                                  const ClipboardData(
                                                      text: "10209804"),
                                                );
                                                Get.snackbar("Copied",
                                                    "ID copied to clipboard");
                                              },
                                              child: const Icon(
                                                Icons.copy,
                                                color: Colors.black54,
                                                size: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomText(
                                      'Agency Code:   2XD56C',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          const ClipboardData(text: "2XD56C"),
                                        );
                                        Get.snackbar("Copied",
                                            "Agency code copied to clipboard");
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        color: Colors.black54,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/supporticon.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const CustomText(
                                    "Support",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    child: CustomContainer(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE0F7E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        "assets/images/rio2.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const CustomText(
                                    "Rio",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/bar_chart.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const CustomText(
                                    "My Agency Level",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  const CustomText(
                                    "C:10%",
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        CustomContainer(
                          conColor: const Color(0xffE9F5FF), // light blue panel bg
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomText(
                                "Invite Creator & Agency",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const CustomText("Number of Host", fontSize: 11),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                                  const Spacer(),
                                  // Orange gradient pill
                                  CustomGradientButton(
                                    text: "Invite Host",
                                    width: 100,
                                    height: 30,
                                    borderRadius: 24,
                                    gradientColors: const [Color(0xffFE7E07), Color(0xffFFDE67)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    textColor: Colors.black,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    onPressed: () => showInviteHostSheet(context),
                                  )

                                ],
                              ),
                              const SizedBox(height: 0.1),
                              Row(
                                children: [
                                  const CustomText("Number of Sub agent", fontSize: 11),
                                  const SizedBox(width: 3),
                                  const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                                  const Spacer(),
                                  // Green gradient pill
                                  CustomGradientButton(
                                    text: "Invite Agency",
                                    width: 100,
                                    height: 30,
                                    borderRadius: 24,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    gradientColors: [Color(0xff11876B), Color(0xffB0FF4B)],
                                    textColor: Colors.black,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    onPressed: () {

                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),



                        const SizedBox(height: 12),

                        // ===== Tabs Row =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CustomText(
                              'SUMMARY',
                              color: Colors.black,
                            ),
                            CustomText(
                              'Mine',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            CustomText('Sub AGENCY', color: Colors.black87),
                            CustomText('Host', color: Colors.black87),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: line,
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/agency_banner.png',
                            fit: BoxFit.contain,
                            height: 30,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            // Host Commission
                            Expanded(
                              child: CustomContainer(
                                conColor: const Color(0xFFB9C7FF),
                                borderRadius: BorderRadius.circular(12),
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      'Host Commission',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                                        const SizedBox(width: 8),
                                        const CustomText(
                                          '0', // <-- inline value
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            const SizedBox(width: 12),

                            // Agency Commission
                            Expanded(
                              child: CustomContainer(
                                conColor: const Color(0xFFE6FFEF),
                                borderRadius: BorderRadius.circular(12),
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      'Agency Commission',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on, color: Colors.orange, size: 18),
                                        const SizedBox(width: 8),
                                        const CustomText(
                                          '0', // <-- inline value
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomContainer(
                          conColor: const Color(0xFFFFCAF3),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  CustomText(
                                    'My Commission',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  Spacer(),
                                  CustomText(
                                    'History list',
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.monetization_on,
                                    color: Color(0xffFDD835),
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  CustomText(
                                    '0',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),


                        const SizedBox(height: 12),

                        // ===== Host list (FIXED) =====
                        CustomContainer(
                          conColor: Color(0xffB5E0E2).withOpacity(.9),
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                          child: Column(
                            children: [
                              _hostItem(
                                hostname: 'عائشة',
                                image: 'profile.png',
                                id: '10207604',
                              ),
                              _hostItem(
                                hostname: 'Reya',
                                image: 'avatar.png',
                                id: '10207605',
                              ),
                              _hostItem(
                                hostname: 'Adnan',
                                image: 'avatar1.png',
                                id: '10207606',
                              ),
                              _hostItem(
                                hostname: 'Saamie',
                                image: 'avatar2.png',
                                id: '10207607',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
  Widget _hostItem({
    required String hostname,
    required String image,
    String id = '10207604',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/$image'),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                hostname,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              CustomText(
                'ID: $id',
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ],
          ),
          const Spacer(),
          // Accept
          CustomGradientButton(
            text: 'Exit',
            width: 84,
            height: 34,
            borderRadius: 8,
            gradientColors: const [
              Color(0xFF8EC2FB),
              Color(0xFFE496FF),
              Color(0xFF32B4FF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            textColor: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            onPressed: () {
              // ✅ popup call here
              Exitagencyshowdialog(context);
            },
          ),


          // Rejected


        ],
      ),
    );
  }
}

