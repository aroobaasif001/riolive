import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String asset;
  final void Function()? onPressed;

  const SocialButton({super.key, required this.asset, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      minWidth: 0,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: const Color(0x33000000),
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(asset), scale: 5),
        ),
      ),
    );
  }
}
