import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

class HostApplicationScreen extends StatelessWidget {
  const HostApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ✅ Put bg image on the root container
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg12.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              const RioliveAppBar(title: 'Host Application333'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    buildHostCard(hostname: 'عائشة', image: 'profile.png'),
                    buildHostCard(hostname: 'Reya', image: 'avatar.png'),
                    buildHostCard(hostname: 'Adnan', image: 'avatar1.png'),
                    buildHostCard(hostname: 'saamie', image: 'avatar2.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHostCard({required String hostname, required String image}) {
    return Center( // center so 375 width card screen ke beech rahe
      child: Container(
        width: 375,
        height: 84,
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFB5E0E2),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Avatar
            Positioned(
              left: 12,
              top: 17,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/$image'),
              ),
            ),

            // Name + ID  (fonts SAME as your code)
            Positioned(
              left: 74, // 12 + (25*2) + 12
              top: 20,
              right: 190, // buttons ke liye space chhod diya
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(hostname, fontWeight: FontWeight.w500, fontSize: 16),
                  const SizedBox(height: 4),
                  const CustomText('ID: 10207604', fontWeight: FontWeight.w500, fontSize: 13),
                ],
              ),
            ),

            // menu dots (top-right)
            const Positioned(
              right: 10,
              top: 10,
              child: Icon(Icons.more_vert, color: Colors.black87),
            ),

            // Buttons (bottom-right) — both height 28
            Positioned(
              right: 10,
              top: 40,
              child: Row(
                children: [
                  // Accept (gradient)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow:  [
                        BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(1, 20)),
                      ],
                    ),
                    child: CustomGradientButton(
                      padding: EdgeInsets.only(bottom: 2),
                      text: 'Accept',
                      width: 76,
                      height: 28,
                      borderRadius: 5,
                      gradientColors: const [Color(0xFF6FD3FF), Color(0xFFB874FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      textColor: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Rejected (same height, shrink tap target)
                  SizedBox(
                    height: 28,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        foregroundColor: const Color(0xFF7A7A7A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const CustomText('Rejected', fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
