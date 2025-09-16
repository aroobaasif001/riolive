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
  final double? scaleFactor; // ✅ Add scale factor for responsiveness

  const CustomCircle({
    super.key,
    this.centerImg,
    this.topLeftImg,
    this.topRightImg,
    this.centerLeftImg,
    this.centerRightImg,
    this.bottomLeftImg,
    this.bottomRightImg,
    this.scaleFactor, // ✅ Optional scale factor
  });

  Widget _buildShadowedImage(String? imgPath, {double size = 60}) {
    if (imgPath == null) return const SizedBox.shrink();
    final scale = scaleFactor ?? 1.0; // ✅ Use scale factor
    final scaledSize = size * scale;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomContainer(
          height: scaledSize,
          width: scaledSize,
          image: const DecorationImage(
            image: AssetImage('assets/images/circle shadow.png'),
            fit: BoxFit.fill,
          ),
        ),
        CustomContainer(
          height: scaledSize - (8 * scale),
          width: scaledSize - (8 * scale),
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.cover),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = scaleFactor ?? 1.0; // ✅ Use scale factor
    
    return Center(
      child: CustomContainer(
        height: 320 * scale,
        width: 350 * scale,
        shape: BoxShape.circle,
        child: Stack(
          children: [
            // Background Circle
            Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                height: 300 * scale,
                width: 300 * scale,
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
                padding: EdgeInsets.only(left: 70 * scale),
                child: _buildShadowedImage(topLeftImg),
              ),
            ),

            // Top Right
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 70 * scale),
                child: _buildShadowedImage(topRightImg),
              ),
            ),

            // Center Circle
            Padding(
              padding: EdgeInsets.only(left: 3 * scale, bottom: 22 * scale),
              child: Align(
                alignment: Alignment.center,
                child: CustomContainer(
                  height: 80 * scale,
                  width: 80 * scale,
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
                padding: EdgeInsets.only(left: 10 * scale),
                child: _buildShadowedImage(centerLeftImg),
              ),
            ),

            // Center Right
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10 * scale),
                child: _buildShadowedImage(centerRightImg),
              ),
            ),

            // Bottom Left
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 70 * scale),
                child: _buildShadowedImage(bottomLeftImg),
              ),
            ),

            // Bottom Right
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 70 * scale),
                child: _buildShadowedImage(bottomRightImg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
