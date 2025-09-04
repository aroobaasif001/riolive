import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import 'customtext.dart';

class HostCircle extends StatelessWidget {
  final String name;
  final String image;
  final bool highlight;
  final bool isHost;
  const HostCircle({
    super.key,
    required this.name,
    required this.image,
    this.highlight = false,
    this.isHost = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          width: 90,
          height: 90,
          shape: BoxShape.circle,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background frame image
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      isHost == true ? "assets/images/frame_2.png" : "",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Avatar in the center
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  backgroundImage: AssetImage(image),
                  radius: 30,
                ),
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
