import 'package:flutter/material.dart';

import 'custom_container.dart';
import 'customtext.dart';

class UserChip extends StatelessWidget {
  const UserChip({
    required this.avatar,
    required this.name,
    required this.trailingGradient,
  });
  final String avatar;
  final String name;
  final List<Color> trailingGradient;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      conColor: Colors.white.withOpacity(.18),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white.withOpacity(.22), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.25),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              avatar,
              width: 35,
              height: 35,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          CustomText(
            name,
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(width: 8),
          CustomContainer(
            width: 35,
            height: 35,
            gradient: LinearGradient(
              colors: trailingGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(25),

            alignment: Alignment.center,
            child: const Icon(
              Icons.person_add_alt,
              color: Colors.white,
              size: 17.5,
            ),
          ),
        ],
      ),
    );
  }
}
