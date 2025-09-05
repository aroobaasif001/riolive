import 'package:flutter/material.dart';

import 'custom_container.dart';

class ShareCircle extends StatelessWidget {
  const ShareCircle({this.asset, this.icon, required this.onTap});
  final String? asset;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: CustomContainer(
        width: 54,
        height: 54,
        conColor: Colors.blue,
        shape: BoxShape.circle,
        alignment: Alignment.center,
        child: asset != null
            ? Image.asset(asset!, width: 54, height: 54, fit: BoxFit.contain)
            : Transform.rotate(
                angle: 135 * 3.14159 / 180, // 45 degrees in radians
                child: Icon(icon ?? Icons.link, size: 34, color: Colors.white),
              ),
      ),
    );
  }
}
