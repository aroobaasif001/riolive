import 'package:flutter/material.dart';

import 'custom_container.dart';
import 'customtext.dart';

class BottomIcon extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback? onTap;

  const BottomIcon({required this.asset, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 👈 will be empty for now
      child: Column(
        children: [
          CustomContainer(
            width: 60, // 28 * 2 (outer radius * 2)
            height: 60,
            conColor: Colors.white, // outer background
            shape: BoxShape.circle,
            child: Padding(
              padding: const EdgeInsets.all(3), // 👈 control inner size
              child: Center(
                child: CircleAvatar(
                  radius: 25, // inner radius
                  backgroundImage: AssetImage(asset),
                  backgroundColor: Colors.transparent,
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
