import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_bubble_model.dart';

class PartyRoomController extends GetxController {
  final hostName = 'Wamiqa J.'.obs;
  final hostId = '7205215'.obs;
  final coin = 100100.obs;

  final stories = <String>[
    'assets/images/story_1.png',
    'assets/images/story_2.png',
    'assets/images/story_3.png',
    'assets/images/story_4.png',
  ].obs;

  final messages = <ChatBubbleModel>[
    ChatBubbleModel(
      name: 'Roshni',
      level: 43,
      text: 'okay… Take Care…',
      hasTranslate: true,
    ),
    ChatBubbleModel(
      name: 'Niklas',
      level: 21,
      text: 'да я уже в угол встал, на горох',
      subText: 'I\'m already in the corner, on the peas.',
      flagged: true,
    ),
    ChatBubbleModel(
      name: 'Twinkle',
      level: 4,
      icon: Icons.circle_outlined,
      text: 'enter the stream 😊',
    ),
    ChatBubbleModel(
      name: 'Danny',
      level: 0,
      icon: Icons.circle_outlined,
      text: 'Hello..',
    ),
  ].obs;
}
