import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/become_a_agent_screen/become_a_agent_screen.dart';

import '../../../../../customwidgets/customtext.dart';
import '../profile_screen/JoinAgency_Screen/JoinAgencyScreen.dart';
class CustomImageButton extends StatelessWidget {
  final String label;
  final LinearGradient gradient;
  final String iconImagePath;
  final VoidCallback? onTap;

  const CustomImageButton({
    super.key,
    required this.label,
    required this.gradient,
    required this.iconImagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: AgencyShapeClipper(), // 👈 sharp top peak
        child: Container(
          height: 160,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Icon inside circle
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  iconImagePath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Text inside whitish container
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // 👈 whitish background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomText(
                  label,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Shape with sharp peak (not rounded)
class AgencyShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curve = 20; // bottom corner radius
    Path path = Path();

    // bottom-left start
    path.moveTo(curve, size.height);

    // bottom-left curve
    path.quadraticBezierTo(0, size.height, 0, size.height - curve);

    // left side
    path.lineTo(0, size.height * 0.4);

    // sharp peak
    path.lineTo(size.width * 0.5, 0);

    // right slope
    path.lineTo(size.width, size.height * 0.4);

    // bottom-right side
    path.lineTo(size.width, size.height - curve);

    // bottom-right curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - curve,
      size.height,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// =========================
/// 🔥 Screen
/// =========================
class AgencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double verticalSpacing = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Agency',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCCF4E2), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              CustomImageButton(
                label: 'Become a agent',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ADE80), Color(0xFFFACC15)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {
                  Get.to(() => const CreateAgencyScreen());
                },
              ),
              SizedBox(height: verticalSpacing),

              CustomImageButton(
                label: 'Join Agency',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {
                  Get.to(() => const JoinAgencyScreen());
                },
              ),
              SizedBox(height: verticalSpacing),

              CustomImageButton(
                label: 'Become a coin seller',
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
