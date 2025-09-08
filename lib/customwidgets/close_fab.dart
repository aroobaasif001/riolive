import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class CloseFab extends StatelessWidget {
  const CloseFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: CustomContainer(
        width: 36,
        height: 36,
        conColor: Color(0xFFFF0000),
        shape: BoxShape.circle,

        alignment: Alignment.center,
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}
