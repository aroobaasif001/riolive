import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buttom_icon.dart';
import 'custom_container.dart';
import 'customtext.dart';
import '../utile/app_url.dart';
import '../controller/random_call_controller.dart';
import 'filter_bottom_sheet.dart';

void showRoomToolsSheet(BuildContext context) {
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
                  _buildOtherToolsRow(context),
                  const SizedBox(height: 10),
                  const CustomText(
                    "Games",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        asset: 'assets/icons/talk_guess.png',
                        label: 'Talk Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/draw_guess.png',
                        label: 'Draw Guess',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/digit_bomb.png',
                        label: 'Digit-Bomb',
                      ),
                      BottomIcon(
                        asset: 'assets/icons/to_be_honest.png',
                        label: 'To Be Honest',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 19.0),
                    child: Row(
                      children: [
                        BottomIcon(
                          asset: 'assets/icons/clap_at_7.png',
                          label: 'Clap at 7',
                        ),
                      ],
                    ),
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

/// Build other tools row - conditionally show Private Call based on user role
Widget _buildOtherToolsRow(context) {
  List<Widget> tools = [
    BottomIcon(
      asset: 'assets/icons/three_circle.png',
      label: 'Filter',
      onTap: (){
        Get.back();
        FilterBottomSheet.show(context);
      },
    ),
    const BottomIcon(
      asset: 'assets/icons/live_time.png',
      label: 'Live Time',
    ),
  ];

  // Show Private Call button for all users but with different functionality
  if (AppUrl.user_role == 'host') {
    // For hosts: Show private call management
    tools.add(
      BottomIcon(
        asset: 'assets/icons/private_call.png',
        label: 'Private Calls',
        onTap: () => _showPrivateCallManagement(),
      ),
    );
  } else {
    // For users: Show private call request with debug functionality
    tools.add(
      BottomIcon(
        asset: 'assets/icons/private_call.png',
        label: 'Private Call',
        onTap: () {
          debugPrint("💎 Private Call button tapped by ${AppUrl.user_name} (${AppUrl.user_role})");
          _handleUserPrivateCall();
        },
      ),
    );
  }

  tools.add(
    const BottomIcon(
      asset: 'assets/icons/admin.png',
      label: 'Admin',
    ),
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: tools,
  );
}

/// Show private call management for hosts
void _showPrivateCallManagement() {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.phone, color: Colors.purple, size: 24),
          SizedBox(width: 8),
          Text(
            'Private Call Management',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'As a host, you can:',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildManagementOption(
            icon: Icons.notifications,
            title: 'Receive Call Requests',
            description: 'Users can send private call requests',
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildManagementOption(
            icon: Icons.check_circle,
            title: 'Accept/Decline Calls',
            description: 'Choose which calls to accept',
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildManagementOption(
            icon: Icons.privacy_tip,
            title: 'Private Sessions',
            description: 'One-on-one calls with users',
            color: Colors.purple,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Got it', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

/// Build management option widget
Widget _buildManagementOption({
  required IconData icon,
  required String title,
  required String description,
  required Color color,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              description,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

/// Show private call host selection dialog
Future<void> _showPrivateCallHostSelection() async {
  try {
    // Show loading while fetching hosts
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.purple),
            SizedBox(width: 16),
            Text('Finding live hosts...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    final controller = Get.find<CallController>();
    final liveHosts = await controller.getLiveHosts(AppUrl.token);
    
    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    
    debugPrint("📋 Found ${liveHosts.length} live hosts for private calls");
    
    if (liveHosts.isEmpty) {
      debugPrint("❌ No live hosts available for private calls");
      
      // Show simple no hosts message
      Get.snackbar(
        '⚠️ No Live Hosts',
        'No hosts are currently available for private calls. Please try again later.',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.search_off, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Show host selection dialog
    _showHostSelectionDialog(liveHosts);
    
  } catch (e) {
    // Close loading if still open
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    
    debugPrint("❌ Error in host selection: $e");
    
    // Show error message
    Get.snackbar(
      '❌ Connection Error',
      'Unable to connect to server. Please check your internet connection and try again.',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      icon: Icon(Icons.wifi_off, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

/// Show host selection dialog
void _showHostSelectionDialog(List<Map<String, dynamic>> liveHosts) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.people, color: Colors.purple, size: 24),
          SizedBox(width: 8),
          Text(
            'Choose Host for Private Call',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 300),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: liveHosts.length,
          itemBuilder: (context, index) {
            final host = liveHosts[index];
            final hostId = host['id'] ?? host['hostId'] ?? 0;
            final hostName = host['username'] ?? host['name'] ?? host['hostName'] ?? 'Unknown Host';
            final isLive = host['is_live'] ?? host['isLive'] ?? true;
            
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isLive ? Colors.green : Colors.grey,
                  radius: 20,
                  child: Icon(
                    isLive ? Icons.videocam : Icons.videocam_off,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  hostName,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'ID: $hostId • ${isLive ? "Live" : "Offline"}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple, size: 16),
                onTap: () async {
                  Get.back(); // Close dialog
                  await _requestPrivateCallToHost(hostId, hostName);
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
      ],
    ),
  );
}

/// Request private call to specific host
Future<void> _requestPrivateCallToHost(int hostId, String hostName) async {
  try {
    debugPrint("🎯 Requesting private call to: $hostName (ID: $hostId)");
    
    // Show loading
    Get.snackbar(
      '📞 Sending Request',
      'Requesting private call to $hostName...',
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      showProgressIndicator: true,
    );
    
    final controller = Get.find<CallController>();
    final result = await controller.requestPrivateCall(
      hostId: hostId,
      hostName: hostName,
      randomCallId: 'private_call_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (result != null && result['status'] == 'success') {
      debugPrint("✅ Private call request sent successfully to $hostName");
      
      Get.snackbar(
        '✅ Request Sent',
        'Private call request sent to $hostName',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        messageText: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request sent to $hostName successfully!', style: TextStyle(color: Colors.white)),
            SizedBox(height: 4),
            Text('Call ID: ${result['privateCall']?['id']}', style: TextStyle(color: Colors.white70, fontSize: 12)),
            SizedBox(height: 4),
            Text('The host will see a popup to accept or decline your call.', style: TextStyle(color: Colors.white60, fontSize: 11)),
          ],
        ),
      );
    } else {
      debugPrint("❌ Private call request failed to $hostName");
      
      Get.snackbar(
        '❌ Request Failed',
        'Failed to send private call request to $hostName',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
    
  } catch (e) {
    debugPrint("💥 Error requesting private call to $hostName: $e");
    
    Get.snackbar(
      '❌ Error',
      'Failed to request private call: ${e.toString()}',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}

/// Show private call options for hosts
void _showHostPrivateCallOptions() {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 24),
          SizedBox(width: 8),
          Text(
            'Host Private Calls',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'As a host, you cannot request private calls from other hosts.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Text(
              'You can only receive private call requests from users while you are live streaming.',
              style: TextStyle(color: Colors.blue, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Got it', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

/// Handle user private call request (for users watching live streams)
void _handleUserPrivateCall() async {
  try {
    debugPrint("🎯 ===========================================");
    debugPrint("🎯 USER INITIATED PRIVATE CALL REQUEST");
    debugPrint("🎯 Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
    debugPrint("🎯 User role: ${AppUrl.user_role}");
    debugPrint("🎯 Token available: ${AppUrl.token?.isNotEmpty ?? false}");
    debugPrint("🎯 Current route: ${Get.currentRoute}");
    debugPrint("🎯 ===========================================");
    
    // Check if user is logged in
    if (AppUrl.token?.isEmpty ?? true) {
      debugPrint("❌ User not logged in - cannot make private calls");
      Get.snackbar(
        '❌ Authentication Required',
        'Please log in to make private calls',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.login, color: Colors.white),
      );
      return;
    }

    // Check if user is not a host (only users can request private calls)
    if (AppUrl.user_role == 'host') {
      debugPrint("⚠️ Host trying to request private call from another host");
      _showHostPrivateCallOptions();
      return;
    }

    debugPrint("✅ User is eligible for private call request - proceeding...");
    
    // Show selection dialog for available hosts or use debug mode
    await _showPrivateCallHostSelection();
    
  } catch (e) {
    debugPrint("💥 ===========================================");
    debugPrint("💥 ERROR IN USER PRIVATE CALL HANDLER!");
    debugPrint("💥 Error: $e");
    debugPrint("💥 Error type: ${e.runtimeType}");
    debugPrint("💥 Stack trace: ${StackTrace.current}");
    debugPrint("💥 ===========================================");
    
    Get.snackbar(
      '❌ Error',
      'Failed to process private call request: ${e.toString()}',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}

  /// Debug: Create a mock private call request for testing (Console only - no dialogs)
void _debugPrivateCallRequest() async {
  try {
    debugPrint("🧪 DEBUG: ==========================================");
    debugPrint("🧪 DEBUG: Starting private call request test");
    debugPrint("🧪 DEBUG: ==========================================");
    
    // Get controller
    final controller = Get.find<CallController>();
    
    // ✅ First check if there are any live hosts
    debugPrint("🧪 DEBUG: Checking for live hosts first...");
    final liveHosts = await controller.getLiveHosts(AppUrl.token);
    
    if (liveHosts.isEmpty) {
      debugPrint("🧪 DEBUG: ❌ No live hosts found!");
      // Don't show snackbar for debug mode - just return silently
      return;
    }
    
    // Use first available live host
    final targetHost = liveHosts.first;
    final hostId = targetHost['id'] ?? targetHost['hostId'] ?? 4;
    final hostName = targetHost['username'] ?? targetHost['name'] ?? 'Live Host';
    
    final mockRandomCallId = 'private_debug_${DateTime.now().millisecondsSinceEpoch}';
    
    debugPrint("🧪 DEBUG: Request Parameters:");
    debugPrint("🧪 DEBUG: - Target Host ID: $hostId");
    debugPrint("🧪 DEBUG: - Target Host Name: $hostName");
    debugPrint("🧪 DEBUG: - Random Call ID: $mockRandomCallId"); 
    debugPrint("🧪 DEBUG: - Current User ID: ${AppUrl.riolive_id}");
    debugPrint("🧪 DEBUG: - User Role: ${AppUrl.user_role}");
    debugPrint("🧪 DEBUG: - Token Available: ${AppUrl.token != null && AppUrl.token!.isNotEmpty}");
    debugPrint("🧪 DEBUG: - Host Data: $targetHost");
    
    // Debug mode - no loading UI for internal testing
    
    // Make the API call directly
    final result = await controller.requestPrivateCall(
      hostId: hostId,
      hostName: hostName,
      randomCallId: mockRandomCallId,
    );

    if (result != null) {
      debugPrint("🧪 DEBUG: ==========================================");
      debugPrint("🧪 DEBUG: ✅ Private call request SUCCESSFUL!");
      debugPrint("🧪 DEBUG: ✅ Response data: $result");
      debugPrint("🧪 DEBUG: ✅ Private Call ID: ${result['privateCall']?['id']}");
      debugPrint("🧪 DEBUG: ✅ Status: ${result['status']}");
      debugPrint("🧪 DEBUG: ✅ Debug Info: ${result['debug']}");
      debugPrint("🧪 DEBUG: ==========================================");
      
      // Debug success - minimal UI
      debugPrint("🧪 DEBUG: Request sent successfully in debug mode");
    } else {
      debugPrint("🧪 DEBUG: ==========================================");
      debugPrint("🧪 DEBUG: ❌ Private call request FAILED!");
      debugPrint("🧪 DEBUG: ❌ Result was null - check API response above");
      debugPrint("🧪 DEBUG: ==========================================");
      
      // Debug failure - minimal UI
      debugPrint("🧪 DEBUG: Request failed in debug mode");
    }
    
  } catch (e) {
    debugPrint("🧪 DEBUG: ==========================================");
    debugPrint("🧪 DEBUG: ❌ EXCEPTION in debug private call request:");
    debugPrint("🧪 DEBUG: ❌ Error: $e");
    debugPrint("🧪 DEBUG: ❌ Error Type: ${e.runtimeType}");
    debugPrint("🧪 DEBUG: ==========================================");
    
    // Debug exception - minimal UI  
    debugPrint("🧪 DEBUG: Exception occurred in debug mode");
  }
}
