import 'package:flutter/material.dart';

import 'custom_container.dart';

class CustomCircle extends StatelessWidget {
  final String? centerImg;
  final String? topLeftImg;
  final String? topRightImg;
  final String? centerLeftImg;
  final String? centerRightImg;
  final String? bottomLeftImg;
  final String? bottomRightImg;

  const CustomCircle({
    super.key,
    this.centerImg,
    this.topLeftImg,
    this.topRightImg,
    this.centerLeftImg,
    this.centerRightImg,
    this.bottomLeftImg,
    this.bottomRightImg,
  });

  Widget _buildShadowedImage(String? imgPath, {double size = 67}) {
    if (imgPath == null) return const SizedBox.shrink();
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomContainer(
          height: size,
          width: size,
          image: const DecorationImage(
            image: AssetImage('assets/images/circle shadow.png'),
            fit: BoxFit.fill,
          ),
        ),
        CustomContainer(
          height: size - 8,
          width: size - 8,
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fill),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomContainer(
        height: 320,
        width: 350,
        shape: BoxShape.circle,
        child: Stack(
          children: [
            // Background Circle
            Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                height: 300,
                width: 300,
                image: const DecorationImage(
                  image: AssetImage('assets/images/circle_img.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Top Left
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 70),
                child: _buildShadowedImage(topLeftImg),
              ),
            ),

            // Top Right
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 70),
                child: _buildShadowedImage(topRightImg),
              ),
            ),

            // Center Circle
            Padding(
              padding: const EdgeInsets.only(left: 3, bottom: 22),
              child: Align(
                alignment: Alignment.center,
                child: CustomContainer(
                  height: 80,
                  width: 80,
                  shape: BoxShape.circle,
                  image: centerImg != null
                      ? DecorationImage(image: AssetImage(centerImg!), fit: BoxFit.cover)
                      : null,
                  conColor: centerImg == null ? Colors.red : null,
                ),
              ),
            ),

            // Center Left
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _buildShadowedImage(centerLeftImg),
              ),
            ),

            // Center Right
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _buildShadowedImage(centerRightImg),
              ),
            ),

            // Bottom Left
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 70),
                child: _buildShadowedImage(bottomLeftImg),
              ),
            ),

            // Bottom Right
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 70),
                child: _buildShadowedImage(bottomRightImg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
