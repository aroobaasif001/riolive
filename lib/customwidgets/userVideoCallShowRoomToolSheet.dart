import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';
import 'customtext.dart';
import '../controller/random_call_controller.dart';
import '../utile/app_url.dart';

void userVideoCallShowRoomToolsSheet(BuildContext context, {
  int? hostId,
  String? hostName,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return CustomContainer(
              conColor: const Color(0xff2D2A2A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 40,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CustomText(
                    "Room Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/share_3.png',
                        label: 'Share',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/flip_camera.png',
                        label: 'Flip Camera',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/sticker.png',
                        label: 'Sticker',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/micro_phone.png',
                        label: 'Micro',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                    "Other Tools",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const BottomIcon(
                        asset: 'assets/icons/three_circle.png',
                        label: 'Filter',
                      ),
                      const BottomIcon(
                        asset: 'assets/icons/live_time.png',
                        label: 'Live Time',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/private_call.png',
                        label: 'Private Call',
                        onTap: () => _handlePrivateCallRequest(context, hostId, hostName),
                      ),
                      const BottomIcon(
                        asset: 'assets/icons/admin.png',
                        icon: Icons.person,
                        label: 'Admin',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

/// Handle private call request from user to host
void _handlePrivateCallRequest(BuildContext context, int? hostId, String? hostName) async {
  try {
    // Validate parameters
    if (hostId == null || hostName == null || hostName.isEmpty) {
      Get.snackbar(
        '❌ Error',
        'Host information not available for private call',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Check if user is logged in
    if (AppUrl.token?.isEmpty ?? true) {
      Get.snackbar(
        '❌ Error',
        'Please log in to make private calls',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Check if user is not a host
    if (AppUrl.user_role == 'host') {
      Get.snackbar(
        '❌ Not Available',
        'Private call is not available for hosts',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Close the tools sheet
    Navigator.pop(context);

    // Show confirmation dialog
    final bool? shouldProceed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '📞 Private Call Request',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Send a private call request to $hostName?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('📞 Send Request', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return;

    // Show loading dialog
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(width: 16),
            Text('Sending request...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Send private call request
    final controller = Get.find<CallController>();
    final result = await controller.requestPrivateCall(
      hostId: hostId,
      hostName: hostName,
    );

    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (result != null) {
      // Success - show waiting dialog
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            '📞 Request Sent',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'Private call request sent to $hostName.\nWaiting for response...',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close waiting dialog
                // TODO: Cancel the private call request if needed
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      debugPrint("✅ Private call request sent successfully: $result");
    } else {
      // Failed to send request
      Get.snackbar(
        '❌ Request Failed',
        'Failed to send private call request to $hostName',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }

  } catch (e) {
    // Close any open dialogs
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    
    debugPrint("❌ Error handling private call request: $e");
    Get.snackbar(
      '❌ Error',
      'An error occurred while sending the request',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
