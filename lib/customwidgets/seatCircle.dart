import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import '../views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_screen.dart';
import 'customtext.dart';

class SeatCircle extends StatelessWidget {
  final SeatState state;
  final String label;
  final String? image;
  final String frameImage; // Added frame image parameter
  final onTap;

  const SeatCircle({
    super.key,
    required this.state,
    required this.label,
    this.image,
    required this.frameImage, // Initialize frame image
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget inner;
    if (state == SeatState.occupied && image != null) {
      inner = CircleAvatar(backgroundImage: AssetImage(image!), radius: 30);
    } else if (state == SeatState.locked) {
      inner = const Icon(Icons.lock, color: Colors.white, size: 30);
    } else {
      inner = const Icon(Icons.mic, color: Colors.white70, size: 30);
    }

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Background frame image
              CustomContainer(
                width: 72,
                height: 72,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(frameImage),
                  fit: BoxFit.cover,
                ),
              ),
              // Inner content (avatar or icon)
              CustomContainer(
                width: 72,
                height: 72,
                shape: BoxShape.circle,
                conColor: state == SeatState.locked
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                child: Center(child: inner),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CustomText(label, color: Colors.white, fontSize: 11),
        ],
      ),
    );
  }
}
