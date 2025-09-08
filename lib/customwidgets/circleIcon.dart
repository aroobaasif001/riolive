import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({required this.icon, this.onTap, this.bg});
  final IconData icon;
  final VoidCallback? onTap;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: (bg ?? Colors.white.withOpacity(.14)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 13.5, color: Colors.white),
      ),
    );
  }
}
