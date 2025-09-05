import 'package:flutter/material.dart';

import '../utile/const.dart';
import 'customtext.dart';

class TitleTab extends StatelessWidget {
  const TitleTab({required this.text, required this.active, this.onTap});
  final String text;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : titleDim;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text,
            color: color,
            fontSize: 13,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: active ? 28 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
