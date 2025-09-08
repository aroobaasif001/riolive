import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import 'customtext.dart';

class HostCircle extends StatelessWidget {
  final String name;
  final String image;
  final bool highlight;
  final bool isHost;
  final double width;
  final double height;
  final String frame;
  final bool isSquare; // 👈 NEW FLAG

  const HostCircle({
    super.key,
    required this.name,
    required this.image,
    this.highlight = false,
    this.isHost = false,
    this.width = 90.0,
    this.height = 90.0,
    this.frame = "assets/images/frame_2.png",
    this.isSquare = false, // 👈 default round
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          width: width,
          height: height,
          shape: BoxShape.circle,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Avatar (piche)
              Padding(
                padding: const EdgeInsets.all(4),
                child: isSquare
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          image,
                          width: width / 1.8,
                          height: width / 1.8,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(image),
                        radius: width / 3,
                      ),
              ),

              // Frame (upar)
              if (isHost)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(frame),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: width,
                  height: height,
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          name,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ],
    );
  }
}
