import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 for Get.back()
import 'package:riolive/customwidgets/waitingListContent.dart';

void showWaitingListSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.back(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.50,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (_, controller) {
              return WaitingListContent(controller: controller);
            },
          ),
        ),
      );
    },
  );
}
