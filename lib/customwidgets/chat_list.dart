import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_video_call_controller.dart';
import 'chat_bubble.dart';

class ChatList extends GetView<UserVideoCallController> {
  const ChatList();
  @override
  Widget build(BuildContext context) {
    final screenW = Get.width;
    return Obx(
      () => ListView.builder(
        itemCount: controller.messages.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_, i) {
          final m = controller.messages[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ChatBubble(m, maxWidth: screenW * 0.68),
          );
        },
      ),
    );
  }
}
