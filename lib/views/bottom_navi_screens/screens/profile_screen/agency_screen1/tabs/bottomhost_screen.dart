import 'package:flutter/material.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../about_riolive_screen/AgencyManagementscreen/Exit_agency_showdialog.dart';
class BottomHostScreen extends StatelessWidget {
  const BottomHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(height: 1, width: double.infinity, color: Colors.green),
          const SizedBox(height: 12),

          // Banner
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/agency_banner.png',
              fit: BoxFit.contain,
              height: 30,
            ),
          ),

          const SizedBox(height: 12),

          // ===== Top two cards (Host / Agency Commission)
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
                          Image.asset(
                            "assets/icons/dolloricon.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const CustomText(
                            '0',
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
                          Image.asset(
                            "assets/icons/dolloricon.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const CustomText(
                            '0',
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

          // ===== My Commission
          _MyCommissionCard(),

          const SizedBox(height: 12),

          // ===== Host list
          CustomContainer(
            conColor: const Color(0xffB5E0E2),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: Column(
              children: [
                hostItem(
                  context,
                  hostname: 'عائشة',
                  image: 'profile.png',
                  id: '10207604',
                ),
                hostItem(
                  context,
                  hostname: 'Reya',
                  image: 'avatar.png',
                  id: '10207605',
                ),
                hostItem(
                  context,
                  hostname: 'Adnan',
                  image: 'avatar1.png',
                  id: '10207606',
                ),
                hostItem(
                  context,
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
    );
  }
}
Widget hostItem(
    BuildContext context, {
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
            Exitagencyshowdialog(context); // dialog call works now
          },
        ),
      ],
    ),
  );
}
class _MyCommissionCard extends StatelessWidget {
  const _MyCommissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        color: const Color(0xFFFFCAF3), // periwinkle blue
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // left block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Commission',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Image.asset('assets/icons/dolloricon.png', height: 28, width: 28),
                    const SizedBox(width: 8),
                    const Text(
                      '0',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // right “History list”
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('History list',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Colors.black54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}