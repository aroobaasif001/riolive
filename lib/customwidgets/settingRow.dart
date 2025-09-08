import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  const SettingRow({
    required this.title,
    required this.trailing,
    this.onInfoTap,
  });

  final String title;
  final Widget trailing;
  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onInfoTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
