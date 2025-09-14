import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../controller/random_call_controller.dart';
import '../../../../../controller/user_video_call_controller.dart';
import '../../../../../customwidgets/coins_chip.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/filter_bottom_sheet.dart';
import '../../../../../customwidgets/message_field.dart';
import '../../../../../customwidgets/plus_count_chip.dart';
import '../../../../../customwidgets/profile_chip.dart';
import '../../../../../customwidgets/round_icon.dart';
import '../../../../../customwidgets/showRoomToolSheet.dart';
import '../../../../../customwidgets/tiny_round.dart';
import '../../../../../services/socket_service.dart';
import '../../../../../utile/app_url.dart';
import '../../home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';
// import '../../home_navbar_screens/match_screen/host_screen.dart';

class HostStartLiveStreamingScreen extends StatefulWidget {
  const HostStartLiveStreamingScreen({super.key});

  @override
  State<HostStartLiveStreamingScreen> createState() =>
      _HostStartLiveStreamingScreenState();
}

class _HostStartLiveStreamingScreenState
    extends State<HostStartLiveStreamingScreen> {
  final callController = Get.put(CallController());
  bool _isInitialized = false;

  /// Ensure we navigate back from this live screen reliably
  Future<void> _exitLiveScreen() async {
    try {
      if (Get.isDialogOpen == true) {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Try normal pop with a result for the previous screen
      Future.microtask(() => Get.back(result: 'ended'));
      await Future.delayed(const Duration(milliseconds: 250));

      // Fallback: if still here, keep popping until we're off this screen
      final routeName = Get.currentRoute;
      if (routeName.contains('HostStartLiveStreamingScreen')) {
        Get.until((route) {
          final name = route.settings.name ?? '';
          return name.isEmpty || !name.contains('HostStartLiveStreamingScreen');
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAgora();
      _attachIncomingCallListeners();
      
      // ✅ Setup host for calls when live streaming screen loads
      _setupHostForCalls();
    });
  }
  
  /// Setup host for receiving calls when live streaming starts
  Future<void> _setupHostForCalls() async {
    try {
      debugPrint("🔴 ===========================================");
      debugPrint("🔴 SETTING UP HOST FOR CALLS");
      debugPrint("🔴 Host going LIVE: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("🔴 Socket connected: ${SocketService.to.isConnected.value}");
      debugPrint("🔴 Current route: ${Get.currentRoute}");
      debugPrint("🔴 ===========================================");
      
      await SocketService.to.setupHostForCalls();
      
      debugPrint("✅ ===========================================");
      debugPrint("✅ HOST SETUP COMPLETED SUCCESSFULLY!");
      debugPrint("✅ Host is now live and ready for:");
      debugPrint("✅ - Random calls (from any users)");
      debugPrint("✅ - Private calls (targeted from specific users)");
      debugPrint("✅ - Socket events are properly attached");
      debugPrint("✅ ===========================================");
      
      // Optional: Run a simple test after a short delay
      Future.delayed(Duration(seconds: 3), () {
        debugPrint("🧪 Running host setup test...");
        SocketService.to.testHostSetup();
      });
      
      // Show success message to host
      Get.snackbar(
        "🎙️ Live Stream Active",
        "You're now live and ready to receive calls!",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.live_tv, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      debugPrint("💥 ===========================================");
      debugPrint("💥 ERROR SETTING UP HOST FOR CALLS!");
      debugPrint("💥 Error: $e");
      debugPrint("💥 Error type: ${e.runtimeType}");
      debugPrint("💥 Stack trace: ${StackTrace.current}");
      debugPrint("💥 ===========================================");
      
      Get.snackbar(
        "❌ Setup Error",
        "Failed to setup host for calls. Some features may not work.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void _attachIncomingCallListeners() {
    debugPrint("🔌 ===========================================");
    debugPrint("🔌 ATTACHING HOST LIVE STREAMING LISTENERS");
    debugPrint("🔌 Socket connected: ${SocketService.to.isConnected.value}");
    debugPrint("🔌 Socket ID: ${SocketService.to.socket?.id}");
    debugPrint("🔌 Host: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
    debugPrint("🔌 ===========================================");
    
    // Remove existing listeners first
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);
    SocketService.to.socket?.off('private_call_request', _onPrivateCallRequest);
    debugPrint("🔌 Removed existing listeners");

    // Attach new listeners
    SocketService.to.socket?.on('incoming_call', _onIncomingCall);
    SocketService.to.socket?.on('call_started', _onIncomingCall);
    SocketService.to.socket?.on('private_call_request', _onPrivateCallRequest);
    
    debugPrint("🔌 ===========================================");
    debugPrint("🔌 LISTENERS ATTACHED SUCCESSFULLY:");
    debugPrint("🔌 - incoming_call (random calls)");
    debugPrint("🔌 - call_started (random calls)");
    debugPrint("🔌 - private_call_request (private calls)");
    debugPrint("🔌 Host is now ready to receive both random and private calls!");
    debugPrint("🔌 ===========================================");
  }

  void _onIncomingCall(dynamic raw) async {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final callerName = (data['callerName'] ?? data['userName'] ?? 'Unknown')
          .toString();

      if (callId.isEmpty) return;

      if (Get.isDialogOpen == true) Get.back();

      Get.dialog(
        AlertDialog(
          title: const Text("📞 Incoming Call"),
          content: Text("$callerName is calling you."),
          actions: [
            TextButton(
              onPressed: () {
                SocketService.to.socket?.emit("call_rejected", {
                  "callId": callId,
                  "userId": AppUrl.riolive_id,
                  "timestamp": DateTime.now().millisecondsSinceEpoch,
                });
                Get.back();
              },
              child: const Text("Reject", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                try {
                  final c = Get.find<CallController>();
                  final joinResp = await c.joinCall(AppUrl.token, callId);
                  if (joinResp == null) {
                    Get.snackbar("Error", "Failed to join call");
                    return;
                  }

                  final channelName =
                      (joinResp['agora']?['channelName'] ??
                              joinResp['call']?['room_id'] ??
                              data['channelName'] ??
                              data['channel'] ??
                              data['roomId'] ??
                              '')
                          .toString();

                  final token =
                      (joinResp['agora']?['hostToken'] ??
                              joinResp['agora']?['token'] ??
                              joinResp['token'] ??
                              data['agora']?['token'] ??
                              data['token'] ??
                              '')
                          .toString();

                  if (channelName.isEmpty || token.isEmpty) {
                    Get.snackbar("Error", "Invalid call data received");
                    return;
                  }

                  SocketService.to.socket?.emit("call_accepted", {
                    "callId": callId,
                    "userId": AppUrl.riolive_id,
                    "userName": AppUrl.user_name,
                    "channelName": channelName,
                    "timestamp": DateTime.now().millisecondsSinceEpoch,
                  });

                  Get.to(
                    () => VideoCallScreen(
                      token: AppUrl.token,
                      callId: callId,
                      channelName: channelName,
                      agoraToken: token,
                      isHost:
                          false, // host yahan live tha, ye call accept as user
                    ),
                  );
                } catch (e) {
                  Get.snackbar("Error", "Failed to accept call: $e");
                }
              },
              child: const Text(
                "Accept",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint("host live incoming_call parse error: $e");
    }
  }

  /// Handle private call requests during live streaming
  void _onPrivateCallRequest(dynamic raw) async {
    try {
      debugPrint("🎙️ ===========================================");
      debugPrint("🎙️ HOST LIVE STREAM - PRIVATE CALL REQUEST!");
      debugPrint("🎙️ Raw event data: $raw");
      debugPrint("🎙️ Data type: ${raw.runtimeType}");
      debugPrint("🎙️ Current route: ${Get.currentRoute}");
      debugPrint("🎙️ Host: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("🎙️ ===========================================");
      
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      // Extract all possible field names from backend
      final privateCallId = (data['privateCallId'] ?? data['callId'] ?? data['id'] ?? '').toString();
      final requesterId = (data['requesterId'] ?? data['callerId'] ?? data['userId'] ?? '').toString();
      final requesterName = (data['requesterName'] ?? data['callerName'] ?? data['userName'] ?? data['message'] ?? 'Unknown User').toString();
      final randomCallId = (data['randomCallId'] ?? '').toString();
      final message = (data['message'] ?? '').toString();
      
      debugPrint("🎙️ ===========================================");
      debugPrint("🎙️ PARSED DATA:");
      debugPrint("🎙️ Private Call ID: '$privateCallId'");
      debugPrint("🎙️ Requester ID: '$requesterId'");
      debugPrint("🎙️ Requester Name: '$requesterName'");
      debugPrint("🎙️ Random Call ID: '$randomCallId'");
      debugPrint("🎙️ Message: '$message'");
      debugPrint("🎙️ All Data Keys: ${data.keys.toList()}");
      debugPrint("🎙️ ===========================================");

      // Validation
      if (privateCallId.isEmpty) {
        debugPrint("❌ Invalid private call request: missing privateCallId");
        debugPrint("❌ Available keys: ${data.keys.join(', ')}");
        return;
      }

      if (requesterId.isEmpty) {
        debugPrint("❌ Invalid private call request: missing requesterId");
        debugPrint("❌ Available keys: ${data.keys.join(', ')}");
        return;
      }
      
      // Clean requester name from message if needed
      String cleanRequesterName = requesterName;
      if (requesterName.contains('sent a private call request')) {
        cleanRequesterName = requesterName.split(' sent a private call request').first.trim();
      }
      if (requesterName.contains('sent you a private call request')) {
        cleanRequesterName = requesterName.split(' sent you a private call request').first.trim();
      }
      
      // Additional cleaning for various message formats
      if (cleanRequesterName.contains('sent') && cleanRequesterName.contains('private')) {
        // Try to extract just the username from various formats
        final parts = cleanRequesterName.split(' ');
        if (parts.isNotEmpty) {
          cleanRequesterName = parts.first; // Take first word as username
        }
      }
      
      debugPrint("🎙️ Cleaned requester name: '$cleanRequesterName' (from: '$requesterName')");

      // Don't show popup if already showing one
      if (Get.isDialogOpen == true) {
        debugPrint("⚠️ Dialog already open, will show private call request after current dialog closes");
        // Queue the request for later
        Future.delayed(Duration(milliseconds: 1000), () {
          if (!Get.isDialogOpen!) {
            _showPrivateCallRequestDialog(privateCallId, requesterId, cleanRequesterName);
          }
        });
        return;
      }

      debugPrint("✅ ===========================================");
      debugPrint("✅ SHOWING PRIVATE CALL REQUEST DIALOG");
      debugPrint("✅ Call ID: $privateCallId");
      debugPrint("✅ From: $cleanRequesterName (ID: $requesterId)");
      debugPrint("✅ ===========================================");

      _showPrivateCallRequestDialog(privateCallId, requesterId, cleanRequesterName);
      
    } catch (e) {
      debugPrint("💥 ===========================================");
      debugPrint("💥 ERROR IN HOST PRIVATE CALL HANDLER!");
      debugPrint("💥 Error: $e");
      debugPrint("💥 Error type: ${e.runtimeType}");
      debugPrint("💥 Raw data: $raw");
      debugPrint("💥 Stack trace: ${StackTrace.current}");
      debugPrint("💥 ===========================================");
    }
  }

  /// Show private call request dialog to host
  void _showPrivateCallRequestDialog(String privateCallId, String requesterId, String requesterName) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: Icon(Icons.person, color: Colors.purple, size: 25),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💎 Private Call Request',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    requesterName,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Text(
          '$requesterName wants to have a private call with you during your live stream.',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          // Reject Button
          TextButton(
            onPressed: () async {
              Get.back();
              await _rejectPrivateCall(privateCallId, requesterId, requesterName);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('❌ Decline', style: TextStyle(color: Colors.red)),
          ),
          // Accept Button  
          TextButton(
            onPressed: () async {
              Get.back();
              await _acceptPrivateCall(privateCallId, requesterId, requesterName);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('✅ Accept', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Accept private call request
  Future<void> _acceptPrivateCall(String privateCallId, String requesterId, String requesterName) async {
    try {
      debugPrint("✅ Accepting private call request: $privateCallId");
      
      // Show loading
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black87,
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(width: 16),
              Text('Accepting call...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Accept via API
      final result = await callController.acceptPrivateCall(callId: privateCallId);
      
      // Close loading dialog
      if (Get.isDialogOpen == true) Get.back();

      if (result != null) {
        debugPrint("✅ Private call accepted successfully");
        
        // Extract call data
        final agora = result['agora'] ?? {};
        final roomId = agora['roomId']?.toString() ?? '';
        final hostToken = agora['host']?['token']?.toString() ?? '';
        final hostUid = agora['host']?['uid']; // ✅ FIX: Extract host UID
        
        if (roomId.isNotEmpty && hostToken.isNotEmpty) {
          debugPrint("📞 ==========================================");
          debugPrint("📞 HOST NAVIGATION TO PRIVATE CALL");
          debugPrint("📞 Room ID: $roomId");
          debugPrint("📞 Host Token: ${hostToken.substring(0, 20)}...");
          debugPrint("📞 Host UID: $hostUid"); // ✅ FIX: Log host UID
          debugPrint("📞 Requester: $requesterName (ID: $requesterId)");
          debugPrint("📞 Private Call ID: $privateCallId");
          debugPrint("📞 Full Agora Data: $agora");
          debugPrint("📞 ==========================================");
          
          Get.snackbar(
            "✅ Private Call Starting",
            "Starting private call with $requesterName...",
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.videocam, color: Colors.white),
          );
          
          // Navigate to private video call screen
          Future.delayed(Duration(milliseconds: 500), () {
            Get.to(
              () => VideoCallScreen(
                token: AppUrl.token,
                callId: privateCallId,
                channelName: roomId,
                agoraToken: hostToken,
                isHost: true, // Host is always host in private call
                providedUid: hostUid, // ✅ FIX: Use backend-provided host UID that matches token
              ),
            );
          });
          
        } else {
          debugPrint("❌ Missing private call data:");
          debugPrint("❌ Room ID: '$roomId'");
          debugPrint("❌ Host Token: '${hostToken.isNotEmpty ? 'Present' : 'Missing'}'");
          debugPrint("❌ Full result: $result");
          
          Get.snackbar(
            "❌ Call Setup Error",
            "Missing call connection data. Please try again.",
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        Get.snackbar(
          "❌ Call Failed",
          "Failed to accept private call request",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen == true) Get.back();
      
      debugPrint("❌ Error accepting private call: $e");
      Get.snackbar(
        "❌ Accept Failed",
        "Error: ${e.toString()}",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Reject private call request
  Future<void> _rejectPrivateCall(String privateCallId, String requesterId, String requesterName) async {
    try {
      debugPrint("❌ Rejecting private call request: $privateCallId");
      
      final result = await callController.rejectPrivateCall(
        callId: privateCallId,
        reason: "Host declined",
      );

      if (result) {
        Get.snackbar(
          "📞 Call Declined",
          "Private call request from $requesterName declined",
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        debugPrint("✅ Private call rejected successfully");
      } else {
        debugPrint("❌ Failed to reject private call");
      }
    } catch (e) {
      debugPrint("❌ Error rejecting private call: $e");
    }
  }

  void _initializeAgora() async {
    if (_isInitialized) return;

    /// get the args passed from previous screen
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      debugPrint("❌ No arguments provided for Agora initialization");
      return;
    }

    debugPrint("Initializing Agora with args: $args");

    /// join agora channel
    await callController.initAgora(
      channelName: args["channelName"],
      agoraToken: args["token"],
      appId: args["appId"],
      isHost: args["isHost"] ?? false,
      isAudience: !(args["isHost"] ?? false),
      callId: args["channelName"], // can also use roomId
    );

    _isInitialized = true;
  }
  
  /// Reinitialize Agora for live streaming after call ends
  Future<void> reinitializeLiveStreaming() async {
    try {
      debugPrint("🔄 Reinitializing live streaming after call...");
      
      // ✅ Force complete cleanup first
      await callController.leaveChannel();
      debugPrint("📱 Left channel for reinitialization");
      
      // ✅ Wait for cleanup to complete
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Reset initialization flag
      _isInitialized = false;
      
      // Get current arguments or use stored ones
      final args = Get.arguments as Map<String, dynamic>?;
      
      if (args != null) {
        debugPrint("🔄 Using existing arguments for reinitialization: $args");
        
        // ✅ Reinitialize with fresh Agora settings
        await callController.initAgora(
          channelName: args["channelName"],
          agoraToken: args["token"],
          appId: args["appId"],
          isHost: args["isHost"] ?? true,
          isAudience: false,
          callId: args["channelName"],
        );
        
        _isInitialized = true;
        debugPrint("✅ Camera reinitialized successfully");
        
      } else {
        debugPrint("⚠ No arguments available - live stream may need manual restart");
        
        // Show message to user
        Get.snackbar(
          "Camera Restart Needed", 
          "Please restart live streaming manually for best results",
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          icon: const Icon(Icons.refresh, color: Colors.white),
        );
      }
      
      // Reattach call listeners
      _attachIncomingCallListeners();
      
      // Re-setup host for calls
      await _setupHostForCalls();
      
      debugPrint("✅ Live streaming reinitialization completed");
      
    } catch (e) {
      debugPrint("❌ Error reinitializing live streaming: $e");
      Get.snackbar(
        "❌ Reinitialization Failed", 
        "Camera restart failed. Please restart live streaming manually.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// ✅ New: Force restart camera if hanging
  Future<void> restartCameraForcefully() async {
    try {
      debugPrint("🔄 Force restarting camera due to hanging...");
      
      // Show loading indicator
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black87,
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(width: 16),
              Text('🔄 Restarting camera...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        barrierDismissible: false,
      );
      
      // Complete shutdown and restart
      await reinitializeLiveStreaming();
      
      // Close loading dialog
      await Future.delayed(const Duration(milliseconds: 1000));
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      Get.snackbar(
        "🔄 Camera Restarted",
        "Camera has been refreshed for smooth streaming!",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.videocam, color: Colors.white),
      );
      
    } catch (e) {
      debugPrint("❌ Error in force camera restart: $e");
      
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      Get.snackbar(
        "❌ Camera Restart Failed",
        "Please restart live streaming manually",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  

  @override
  void dispose() {
    // cleanup listeners
    SocketService.to.socket?.off('incoming_call', _onIncomingCall);
    SocketService.to.socket?.off('call_started', _onIncomingCall);
    SocketService.to.socket?.off('private_call_request', _onPrivateCallRequest);

    // ✅ Remove host from calls when live streaming ends
    _removeHostFromCalls();

    try { callController.engine?.stopPreview(); } catch (_) {}
    callController.leaveChannel();
    try { callController.engine?.release(); } catch (_) {}
    callController.engine = null;
    super.dispose();
  }
  

  /// Remove host from calls when live streaming ends
  Future<void> _removeHostFromCalls() async {
    try {
      debugPrint("⚫ Host ending live stream - removing from calls...");
      await SocketService.to.removeHostFromCalls();
    } catch (e) {
      debugPrint("❌ Error removing host from calls: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(UserVideoCallController());

    return WillPopScope(
      onWillPop: () async {
        final bool? confirm = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              "End Live Stream?",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Are you sure you want to end your live stream?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("No", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text("Yes, End", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (confirm == true) {
          try {
            // Inform backend host is off live (best-effort)
            await http.post(
              Uri.parse(AppUrl.offLiveLiveCall),
              headers: {'Authorization': "Bearer ${AppUrl.token}"},
            );

            final args = Get.arguments as Map<String, dynamic>?;
            if (args != null && (args["isHost"] == true)) {
              await callController.endCall(AppUrl.token, args["channelName"]);
            }

            // Cleanup Agora and socket host availability
            try { await callController.engine?.stopPreview(); } catch (_) {}
            await callController.leaveChannel();
            try { await callController.engine?.release(); } catch (_) {}
            callController.engine = null;
            await SocketService.to.removeHostFromCalls();

            // Go back to the screen user started live from
            await _exitLiveScreen();
          } catch (_) {}
          return false; // navigation already handled
        }
        return false; // cancel back
      },
      child: Scaffold(
        body: Stack(
        children: [
          /// 🔹 Agora Video
          Obx(() {
            if (callController.hasError.value) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        callController.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          final args = Get.arguments as Map<String, dynamic>;
                          callController.initAgora(
                            channelName: args["channelName"],
                            agoraToken: args["token"],
                            appId: args["appId"],
                            isHost: args["isHost"] ?? false,
                            isAudience: !(args["isHost"] ?? false),
                            callId: args["channelName"],
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (callController.isJoined.value) {
              if (callController.remoteUid.value != null) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: callController.engine!,
                    canvas: VideoCanvas(uid: callController.remoteUid.value),
                    connection: RtcConnection(
                      channelId: callController.channel ?? "",
                    ),
                  ),
                );
              } else {
                return AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: callController.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                );
              }
            } else {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        "Connecting to live stream...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),

          /// 🔹 UI Overlay - Only show if joined successfully
          Obx(
            () => callController.isJoined.value
                ? SafeArea(
                    child: Stack(
                      children: [
                        /// ========= Profile + Top Bar =========
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Left: Profile info
                              ProfileChip(
                                false,
                                Colors.white.withOpacity(0.2),
                                "${AppUrl.user_name}",
                                "${AppUrl.riolive_id}",
                              ),

                              /// Right: Story circles + close button
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  const TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_2.png',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const TinyRound(
                                    size: 30,
                                    image: AssetImage(
                                      'assets/images/story_3.jpg',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const PlusCountChip(countText: '+98'),
                                  const SizedBox(width: 8),

                                  /// Close button (with confirmation)
                                  CloseButton(
                                    color: Colors.white,
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final bool? confirm = await Get.dialog<bool>(
                                        AlertDialog(
                                          backgroundColor: Colors.black87,
                                          title: const Text(
                                            "End Live Stream?",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                            "Are you sure you want to end your live stream?",
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(result: false),
                                              child: const Text("No", style: TextStyle(color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () => Get.back(result: true),
                                              child: const Text("Yes, End", style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                        barrierDismissible: false,
                                      );

                                      if (confirm == true) {
                                        try {
                                          await http.post(
                                            Uri.parse(AppUrl.offLiveLiveCall),
                                            headers: {'Authorization': "Bearer ${AppUrl.token}"},
                                          );

                                          final args = Get.arguments as Map<String, dynamic>?;
                                          if (args != null && (args["isHost"] == true)) {
                                            await callController.endCall(AppUrl.token, args["channelName"]);
                                          }

                                          try { await callController.engine?.stopPreview(); } catch (_) {}
                                          await callController.leaveChannel();
                                          try { await callController.engine?.release(); } catch (_) {}
                                          callController.engine = null;
                                          await SocketService.to.removeHostFromCalls();

                                          // Go back to the originating screen
                                          await _exitLiveScreen();
                                        } catch (e) {
                                          debugPrint("End live error: $e");
                                          Get.back();
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// ========= Reward Popup =========
                        Positioned(
                          top: 70,
                          left: size.width * 0.02,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CoinsChip(
                                    "50",
                                    Colors.greenAccent.withOpacity(0.5),
                                    true,
                                  ),
                                  const SizedBox(width: 5),
                                  CoinsChip(
                                    "00 / 00 / 00",
                                    Colors.purple.withOpacity(0.5),
                                    false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              /// Popup Box
                              CustomContainer(
                                width: size.width * 0.75,
                                borderRadius: BorderRadius.circular(15),
                                conColor: Colors.white.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Level Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomContainer(
                                          conColor: Colors.lightBlue
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CustomText(
                                              "💎 Level 1",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        CustomContainer(
                                          conColor: Colors.purple.withOpacity(
                                            0.4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CustomText(
                                              "0/60 Min",
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        CustomContainer(
                                          conColor: Colors.greenAccent
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  size: 16,
                                                  color: Color(0xffFFC86B),
                                                ),
                                                SizedBox(width: 4),
                                                CustomText(
                                                  "1000/H",
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    /// Progress Bar
                                    CustomContainer(
                                      height: 14,
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.deepOrangeAccent,
                                        ],
                                      ),
                                      width:
                                          (size.width * 0.7) *
                                          0.0, // progress value
                                    ),
                                    const SizedBox(height: 8),

                                    CustomContainer(
                                      width: double.infinity,
                                      conColor: Colors.greenAccent.withOpacity(
                                        0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.monetization_on,
                                                size: 16,
                                                color: Color(0xffFFC86B),
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                "0",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              SizedBox(width: 6),
                                              CustomText(
                                                "/",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              SizedBox(width: 6),
                                              Icon(
                                                Icons.monetization_on,
                                                size: 16,
                                                color: Color(0xffFFC86B),
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                "100000",
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ========= Bottom Bar =========
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: [
                              const Expanded(child: MessageField()),
                              const SizedBox(width: 12),
                              
                              // ✅ Filter button (responsive) - opens bottom sheet
                              InkWell(
                                onTap: () {
                                  debugPrint("🎨 Filter button tapped!");
                                  FilterBottomSheet.show(context);
                                },
                                child: Container(
                                  width: size.width > 600 ? 48 : 40,
                                  height: size.width > 600 ? 48 : 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.filter_vintage,
                                    color: Colors.white,
                                    size: size.width > 600 ? 24 : 20,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              // ✅ Camera restart button - for fixing hanging camera
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /// Top Row (Tabs + Icons)
                                            Row(
                                              children: [
                                                Text("Waiting", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                                SizedBox(width: 12),
                                                Text("Guest Live", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 18)),
                                                Spacer(),
                                                CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor: Colors.grey.shade800,
                                                  child: Icon(Icons.question_mark, color: Colors.white, size: 18),
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(context),
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor: Colors.red,
                                                    child: Icon(Icons.close, color: Colors.white, size: 18),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            /// Waiting List Title
                                            Text("Waiting List (2)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),

                                            SizedBox(height: 16),

                                            /// Waiting List Items (Repeatable Widget)
                                            ...List.generate(2, (index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                child: Row(
                                                  children: [
                                                    /// User Image
                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 24,
                                                          backgroundImage: AssetImage("assets/images/profile.png"), // Replace with real user image
                                                        ),
                                                        Positioned(
                                                            bottom: -5,
                                                            right: -10,
                                                            child: Image.asset("assets/icons/signal.png",height: 30,))
                                                      ],
                                                    ),

                                                    SizedBox(width: 12),

                                                    /// Username + Badge
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Ava😎Nueva❤️😘", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                                          SizedBox(height: 4),
                                                          Image.asset("assets/icons/level.png", height: 18)
                                                        ],
                                                      ),
                                                    ),

                                                    /// Accept / Reject Buttons
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                            decoration: BoxDecoration(
                                                                color: Colors.green,
                                                                borderRadius: BorderRadius.circular(20)
                                                            ),
                                                            child: Text("Accept",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ),
                                                        SizedBox(width: 6),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              color: Colors.red,
                                                                borderRadius: BorderRadius.circular(20)
                                                            ),
                                                            child: Text("Reject",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  },
                                child: Container(
                                  width: size.width > 600 ? 48 : 40,
                                  height: size.width > 600 ? 48 : 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(Icons.chair_outlined,color: Colors.white,),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              InkWell(
                                onTap: (){
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF012020), // dark teal or custom dark color
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            /// 🔹 Top Bar
                                            Row(
                                              children: [
                                                Icon(Icons.history, color: Colors.white60),
                                                SizedBox(width: 10,),
                                                InkWell(
                                                    onTap: (){
                                                      showPkSettingBottomSheet(context);
                                                    },
                                                    child: Icon(Icons.settings_outlined, color: Colors.white60)),
                                                Spacer(),
                                                Text(
                                                  "PK",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(context),
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor: Colors.red,
                                                    child: Icon(Icons.close, size: 18, color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            /// 🔹 PK Mode Options
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                _pkModeOption("1v1PK", "assets/icons/1v1.png"),
                                                _pkModeOption("Team PK", "assets/icons/team.png"),
                                                _pkModeOption("Multi PK", "assets/icons/multi_pk.png"),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            /// 🔹 Random PK
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFC30D).withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white12,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset("assets/icons/random_pk.png", height: 24)), // Replace with your icon
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      "Random PK",
                                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white54,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.1),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: Offset(0, 1),
                                                        ),
                                                      ]
                                                    ),
                                                    child: Center(child: CustomText("Start",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            /// 🔹 Friends Section
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Friends",
                                                style: TextStyle(color: Colors.white70, fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "No friends available for invitation, we recommend the following opponents for you",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white38, fontSize: 12),
                                            ),

                                            SizedBox(height: 20),

                                            /// 🔹 System Suggestions
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "System Suggestions",
                                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                            ),

                                            SizedBox(height: 10),

                                            /// 🔹 Suggested Users List
                                            ...List.generate(2, (index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    /// Profile image
                                                    Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 24,
                                                          backgroundImage: AssetImage("assets/images/profile.png"), // Replace with real user image
                                                        ),
                                                        Positioned(
                                                            bottom: -5,
                                                            right: -10,
                                                            child: Image.asset("assets/icons/signal.png",height: 30,))
                                                      ],
                                                    ),
                                                    SizedBox(width: 12),

                                                    /// Name and badge
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Ava😎Nueva❤️😘", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                                          Row(
                                                            children: [
                                                              Image.asset("assets/icons/L1_badge.png", height: 16), // Mic icon
                                                              SizedBox(width: 4),
                                                              Image.asset("assets/icons/gender.png", height: 16), // Fire badge icon
                                                              SizedBox(width: 6),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Text(
                                                                  "Lv60",
                                                                  style: TextStyle(color: Color(0xff604132), fontSize: 12),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    /// Invite button

                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white30,
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 1,
                                                              offset: Offset(0, 1),
                                                            ),
                                                          ]
                                                      ),
                                                      child: Center(child: CustomText("Invite",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                                    ),



                                                  ],
                                                ),
                                              );
                                            }),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                },
                                child: const RoundIcon(
                                  image: AssetImage('assets/icons/pk.png'),
                                ),
                              ),
                              const SizedBox(width: 14),
                              InkWell(
                                onTap: () => showRoomToolsSheet(context),
                                child: const RoundIcon(
                                  image: AssetImage('assets/icons/apps.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      ),
    );
  }
  Widget _pkModeOption(String label, String iconPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, height: 28),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

}


void showPkSettingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF012020), // background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Center(
                    child: Text(
                      "PK Setting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30), // for balance
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PK Type (1v1, Multi, Team)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _segmentButton("1v1 PK", true),
                _segmentButton("Multi PK", false),
                _segmentButton("Team PK", false),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PK Mode (Single Round, Best of 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText("PK Mode",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                Spacer(),
                _modeButton("Single Round PK", true),
                SizedBox(width: 10,),
                _modeButton("Best of three PK", false),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 Time Selector
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const CustomText("Time", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
              trailing: SizedBox(
                width: 80,
                child: Center(
                  child: Row(
                    children: [
                      const CustomText("5min", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                      SizedBox(width: 10,),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              onTap: (){
                showPkTimeBottomSheet(context);
                },
            ),

            // const Divider(color: Colors.white24),

            /// 🔹 Toggle
            SwitchListTile(
              value: false,
              onChanged: (val) {
                // TODO: handle toggle
              },
              activeColor: Colors.green,
              title: const Text(
                "Will PK be opened directly after the Connection",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 Random PK region preference
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    "Random PK region preference",
                    style: TextStyle(color: Colors.black),
                  ),
                  CustomText(
                    "Global",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Info Text
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. An effective PK: charm value > 3000\n"
                    "2. if the PK setting of matched hosts is different, one\n"
                    "3. host’s settings will be selected randomly",
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

/// Helper widget for segment button (PK type)
Widget _segmentButton(String text, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFF3D46BE).withOpacity(0.5) : Colors.grey[700],
      borderRadius: BorderRadius.circular(20),
      border: selected ? Border.all(color: Color(0xff28FF4F),width: 0.5) : null,
    ),
    child: Text(
      text,
      style: TextStyle(
        color: selected ? Colors.white : Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// Helper widget for PK mode button
Widget _modeButton(String text, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[700],
      borderRadius: BorderRadius.circular(20),
      border: selected ? Border.all(color: Colors.yellow[700]!,width: 1.5) : null,
    ),
    child: CustomText(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}




void showPkTimeBottomSheet(BuildContext context) {
  int selectedIndex = 0; // 0 = 5mins, 1 = 10mins (disabled for now)

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF012020),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Pk Battle Time",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Options
                Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => selectedIndex = 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            "5mins",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(
                        child: Text(
                          "10mins",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff00FF55).withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, selectedIndex == 0 ? "5min" : "10min");
                      },
                      child: const CustomText("Confirm",style: TextStyle(color: Color(0xffFFD964)),),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
