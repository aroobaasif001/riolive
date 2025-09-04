import 'package:flutter/material.dart';

import 'round_glow.dart';

class CloseButton extends StatelessWidget {
  const CloseButton();

  @override
  Widget build(BuildContext context) {
    return const RoundGlow(
      color: Colors.red,
      size: 32,
      child: Icon(Icons.close, size: 18, color: Colors.white),
    );
  }
}
