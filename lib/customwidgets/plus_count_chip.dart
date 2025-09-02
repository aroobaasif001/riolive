import 'package:flutter/material.dart';

import 'customtext.dart';
import 'frosted_pill.dart';

class PlusCountChip extends StatelessWidget {
  final String countText;
  const PlusCountChip({required this.countText});

  @override
  Widget build(BuildContext context) {
    return FrostedPill(
      width: 35,
      height: 30,
      padding: const EdgeInsets.all(5),
      child: CustomText(
        countText,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }
}
