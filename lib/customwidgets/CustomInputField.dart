import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final Widget? suffix;
  final suffixIcon;
  final keyboardType;
  final maxLines;
  final void Function()? onTap;
  final controller;
  final prefixIcon;

  CustomInputField({
    super.key,
    required this.hintText,
    this.suffix,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines,
    this.onTap,
    this.controller,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade300.withOpacity(0.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: suffix, // 👈 yahan suffix aa jayega
      ),
    );
  }
}
