import 'package:flutter/material.dart';

import 'custom_container.dart';

class TinyRound extends StatelessWidget {
  final double size;
  final ImageProvider image;
  const TinyRound({required this.size, required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size,
      width: size,
      shape: BoxShape.circle,
      image: DecorationImage(image: image, fit: BoxFit.cover),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
