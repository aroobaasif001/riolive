import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import '../views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_screen.dart';
import 'customtext.dart';

class SeatCircle extends StatelessWidget {
  final SeatState state;
  final String label;
  final String? image;
  const SeatCircle({
    super.key,
    required this.state,
    required this.label,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    Widget inner;
    if (state == SeatState.occupied && image != null) {
      inner = CircleAvatar(backgroundImage: AssetImage(image!), radius: 32);
    } else if (state == SeatState.locked) {
      inner = const Icon(Icons.lock, color: Colors.white, size: 30);
    } else {
      inner = const Icon(Icons.mic, color: Colors.white70, size: 30);
    }

    return Column(
      children: [
        CustomContainer(
          width: 72,
          height: 72,
          shape: BoxShape.circle,
          conColor: Colors.black54,
          child: Center(child: inner),
        ),
        const SizedBox(height: 6),
        CustomText(label, color: Colors.white, fontSize: 11),
      ],
    );
  }
}
