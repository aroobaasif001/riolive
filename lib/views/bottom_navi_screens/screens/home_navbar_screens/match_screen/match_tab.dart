import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_circle.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';

import '../../../../../controller/random_call_controller.dart';
import '../../../../../socket/incoming_calls.dart';
import '../../../../../utile/app_url.dart';

class MatchTab extends StatelessWidget {
  final String token;
  MatchTab({super.key, required this.token});

  final CallController _callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 50),
          CustomCircle(
            centerImg: 'assets/images/girl_img2.png',
            topLeftImg: 'assets/images/girl_img2.png',
            topRightImg: 'assets/images/girl_img2.png',
            centerLeftImg: 'assets/images/girl_img2.png',
            centerRightImg: 'assets/images/girl_img2.png',
            bottomLeftImg: 'assets/images/girl_img2.png',
            bottomRightImg: 'assets/images/girl_img2.png',
          ),
          const SizedBox(height: 40),
          const CustomText(
            'Match Random Video Call',
            color: Color(0xff5EBFEF),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontType: AppFont.poppins,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(image: AssetImage('assets/icons/diamondicon.png'), height: 20, width: 27),
              CustomText(
                '800/min',
                color: Color(0xff60ED59),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontType: AppFont.poppins,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                await startRandomCall();
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/icons/phoneicon.png', fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Start random 1-to-1 call (user side)
  Future<void> startRandomCall() async {
    debugPrint("📞 Starting random call...");
    debugPrint("🔍 Current user ID: ${AppUrl.riolive_id}");
    debugPrint("🔍 Current user name: ${AppUrl.user_name}");
    debugPrint("🔍 Token: ${token.isNotEmpty ? "Present" : "Missing"}");

    // Check for active live hosts
    debugPrint('🔍 Checking for active live hosts...');
    final liveHosts = await _callController.getLiveHosts(token);
    debugPrint('🔍 Active live hosts found: ${liveHosts.length}');

    if (liveHosts.isNotEmpty) {
      debugPrint('🔍 Live hosts details:');
      for (int i = 0; i < liveHosts.length; i++) {
        final host = liveHosts[i];
        debugPrint('   Host ${i + 1}: ID=${host['id']}, Name=${host['name']}, Room=${host['room_id']}, Live=${host['is_live']}');
      }
    }

    // Check socket status before starting call
    debugPrint("🔍 Checking socket status...");

    // Check if SocketService exists in GetX
    debugPrint("🔍 Checking if SocketService exists in GetX...");
    if (Get.isRegistered<SocketService>()) {
      debugPrint("✅ SocketService is registered in GetX");
    } else {
      debugPrint("❌ SocketService is NOT registered in GetX");
    }

    try {
      final socketService = Get.find<SocketService>();
      debugPrint("✅ Found SocketService instance");
      socketService.debugSocketStatus();

      // If socket is not connected, try to force reconnect
      if (socketService.socket?.connected != true) {
        debugPrint("⚠️ Socket not connected, attempting to force reconnect...");
        socketService.forceReconnect(AppUrl.token, AppUrl.riolive_id.toString());

        // Wait a bit for reconnection
        await Future.delayed(const Duration(seconds: 2));

        // Check status again
        socketService.debugSocketStatus();
      }
    } catch (e) {
      debugPrint("❌ Error accessing socket service: $e");
      debugPrint("🔄 Attempting to create socket service...");

      // Try to create the socket service if it doesn't exist
      try {
        final socketService = Get.put(SocketService());
        socketService.initSocket(AppUrl.token, AppUrl.riolive_id.toString());
        debugPrint("✅ Socket service created and initialized");

        // Wait a bit for connection
        await Future.delayed(const Duration(seconds: 3));

        // Check final status
        socketService.debugSocketStatus();
      } catch (createError) {
        debugPrint("❌ Failed to create socket service: $createError");
      }
    }

    final response = await _callController.startCall(token);

    if (response != null) {
      debugPrint("✅ Random call API response: $response");

      final callId = response['call']?['id']?.toString() ?? "";
      final channelName = response['agora']?['channelName'] ?? response['call']?['room_id'] ?? "";
      var agoraToken = response['agora']?['callerToken'] ?? response['agora']?['token'] ?? "";

      debugPrint("🔍 Call ID: $callId");
      debugPrint("🔍 Channel Name: $channelName");
      debugPrint("🔍 Agora Token: ${agoraToken.isNotEmpty ? "Present" : "Missing"}");

      if (agoraToken.isEmpty && channelName.isNotEmpty) {
        debugPrint("🔄 Fetching Agora token...");
        final uid = int.tryParse(AppUrl.riolive_id.toString()) ?? 0;
        agoraToken =
            await _callController.fetchAgoraToken(
              token: token,
              channelName: channelName,
              uid: uid,
              role: 'publisher',
            ) ??
            "";
        debugPrint("🔍 Fetched Agora Token: ${agoraToken.isNotEmpty ? "Present" : "Missing"}");
      }

      if (callId.isEmpty || channelName.isEmpty || agoraToken.isEmpty) {
        debugPrint("❌ Invalid call response - Missing data:");
        debugPrint("   Call ID: ${callId.isEmpty ? "MISSING" : "Present"}");
        debugPrint("   Channel Name: ${channelName.isEmpty ? "MISSING" : "Present"}");
        debugPrint("   Agora Token: ${agoraToken.isEmpty ? "MISSING" : "Present"}");
        Get.snackbar("Error", "Invalid call response from server.");
        return;
      }

      debugPrint("📡 Socket notification should have been sent from startCall()");
      debugPrint("🚀 Navigating to VideoCallScreen...");

      Get.to(
        () => VideoCallScreen(
          token: token,
          callId: callId,
          channelName: channelName,
          agoraToken: agoraToken,
          isHost: false, // user side (broadcaster in 1:1)
        ),
      );
    } else {
      debugPrint("❌ Random call API response is null");
      Get.snackbar("Error", "Failed to start call");
    }
  }
}
