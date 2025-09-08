import 'package:flutter/material.dart';

import 'custom_container.dart';
import 'customtext.dart';

class BottomIcon extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback? onTap;
  final IconData? icon; // 👈 NEW optional icon

  const BottomIcon({
    required this.asset,
    required this.label,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 👈 will be empty for now
      child: Column(
        children: [
          CustomContainer(
            width: 60,
            height: 60,
            conColor: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 28, color: Colors.white)
                  : ClipOval(
                      child: Image.asset(
                        asset,
                        fit: BoxFit.cover, // 👈 image circle ke andar adjust
                        width: 45,
                        height: 45,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 6),
          CustomText(
            label,
            style: const TextStyle(fontSize: 12),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
