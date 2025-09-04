import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import 'customtext.dart';

class HostCircle extends StatelessWidget {
  final String name;
  final String image;
  final bool highlight;
  const HostCircle({
    super.key,
    required this.name,
    required this.image,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          width: 90,
          height: 90,
          shape: BoxShape.circle,
          gradient: highlight
              ? const LinearGradient(
                  colors: [Colors.greenAccent, Colors.orangeAccent],
                )
              : const LinearGradient(colors: [Colors.white24, Colors.white12]),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(backgroundImage: AssetImage(image), radius: 40),
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
