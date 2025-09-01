import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../customwidgets/customtext.dart';
import '../profile_screen/JoinAgency_Screen/JoinAgencyScreen.dart';
import '../profile_screen/about_riolive_screen/about_screen.dart';

class CustomImageButton extends StatelessWidget {
  final String label;
  final String backgroundImagePath;
  final String iconImagePath;
  final String? imagePath;
  final void Function()? onTap;
  final double width;

  const CustomImageButton({
    super.key,
    required this.label,
    required this.backgroundImagePath,
    required this.iconImagePath,
    this.onTap,
    this.imagePath,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              backgroundImagePath,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 140,
            child: Image.asset(iconImagePath, width: width),
          ),
          Positioned(
            bottom: 16,
            child: CustomText(
               label,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


class AgencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double verticalSpacing =
        MediaQuery.of(context).size.height * 0.03; // 🔹 kam gap
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: CustomGradient.mainBackground,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 🔹 top align
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Become an agent
              CustomImageButton(
                label: 'Become a agent',
                backgroundImagePath: 'assets/images/agency1.png',
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {},
                imagePath: null,
                width: 48,
              ),
              SizedBox(height: verticalSpacing),

              // Join Agency
              CustomImageButton(
                label: 'Join Agency',
                backgroundImagePath: 'assets/images/agency2.png',
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {
                  Get.to(()=> JoinAgencyScreen());
                },
                imagePath: null,
                width: 48,
              ),
              SizedBox(height: verticalSpacing),

              // Become a coin seller
              CustomImageButton(
                label: 'Become a coin seller',
                backgroundImagePath: 'assets/images/agency3.png',
                iconImagePath: 'assets/images/icone1.png',
                onTap: () {},
                imagePath: null,
                width: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =========================
/// 🔥 Custom Widgets (inside this file)
/// =========================

/// Custom Text Widget


/// Custom Image Widget
class CustomImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;

  const CustomImage({
    super.key,
    required this.path,
    this.width = 50,
    this.height = 50,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
    );
  }
}