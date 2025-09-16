import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSubmitted;
  final VoidCallback? onEmojiPressed;

  const MessageField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onEmojiPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // Dark background to match image
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text Input Field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: 'Say Hi…',
                  hintStyle: TextStyle(
                    color: Colors.white60, // White hint text
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onFieldSubmitted: (_) => onSubmitted?.call(),
              ),
            ),
          ),
          
          // Emoji Button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onEmojiPressed,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.black54,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
