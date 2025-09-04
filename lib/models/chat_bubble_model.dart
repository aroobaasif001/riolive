import 'package:flutter/material.dart';

class ChatBubbleModel {
  final String name;
  final int? level;
  final IconData? icon;
  final String text;
  final String? subText;
  final bool hasTranslate;
  final bool flagged;
  ChatBubbleModel({
    required this.name,
    this.level,
    this.icon,
    required this.text,
    this.subText,
    this.hasTranslate = false,
    this.flagged = false,
  });
}
