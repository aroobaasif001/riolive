import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/controller/random_call_controller.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;

  // De-dupe dialogs per callId
  final Set<String> _pendingCallDialogs = {};
  final Set<String> _processedCallIds = {};

  void initSocket(String token, String userId) {
    debugPrint("🔌 Initializing socket for user: $userId");

    socket = IO.io(
      AppUrl.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setQuery({"token": token})
          .build(),
    );

    socket?.onConnect((_) {
      debugPrint("✅ Socket connected");
      socket?.emit("authenticate", {
        "userId": userId,
        "userRole": AppUrl.user_role,
      });
    });

    socket?.onDisconnect((_) {
      debugPrint("❌ Socket disconnected");
      _pendingCallDialogs.clear();
      _processedCallIds.clear();
    });

    socket?.onConnectError((data) {
      debugPrint("🚨 Socket connection error: $data");
    });

    // ======== LISTENERS ========

    // Clear existing listeners to avoid duplicates
    socket?.off("call_started");
    socket?.off("call_accepted");
    socket?.off("call_rejected");
    socket?.off("call_ended");
    socket?.off("host_joined");

    // Listen for when users start calls (hosts receive this)
    socket?.on("call_started", (raw) async {
      debugPrint("📞 Received call_started: $raw");

      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final callerName =
          (data['callerName'] ?? data['userName'] ?? 'Unknown User').toString();
      final callerId = (data['callerId'] ?? data['userId'] ?? '').toString();

      if (callId.isEmpty) {
        debugPrint("⚠️ call_started without callId");
        return;
      }

      // Ignore if it's from self
      if (callerId == AppUrl.riolive_id.toString()) {
        debugPrint("🚫 Ignoring own call");
        return;
      }

      // Only show to hosts who are live
      if (AppUrl.user_role?.toLowerCase() != 'host') {
        debugPrint("🚫 Not a host, ignoring call notification");
        return;
      }

      // Check if we already processed this call
      if (_processedCallIds.contains(callId)) {
        debugPrint("🚫 Already processed call: $callId");
        return;
      }

      // Check if dialog already showing for this call
      if (_pendingCallDialogs.contains(callId)) {
        debugPrint("🚫 Dialog already showing for call: $callId");
        return;
      }

      _pendingCallDialogs.add(callId);
      _processedCallIds.add(callId);

      // Close any existing dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      debugPrint("📲 Showing incoming call dialog for: $callerName");

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.phone_in_talk, color: Colors.green),
              const SizedBox(width: 8),
              const Text("Incoming Call"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$callerName wants to video call you"),
              const SizedBox(height: 8),
              Text(
                "Call ID: $callId",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _rejectCall(callId),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Decline"),
            ),
            ElevatedButton(
              onPressed: () => _acceptCall(callId, data),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                "Accept",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });

    // Listen for call acceptance confirmation
    socket?.on("call_accepted", (raw) {
      debugPrint("✅ Call accepted: $raw");
      // Handle any UI updates needed when call is accepted
    });

    // Listen for call rejection
    socket?.on("call_rejected", (raw) {
      debugPrint("❌ Call rejected: $raw");
      final data = raw is Map ? Map<String, dynamic>.from(raw) : {};
      final callId = data['callId']?.toString() ?? '';
      _pendingCallDialogs.remove(callId);

      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar("Call Rejected", "The host declined your call");
    });

    // Listen for call end
    socket?.on("call_ended", (raw) {
      debugPrint("📞 Call ended: $raw");
      final data = raw is Map ? Map<String, dynamic>.from(raw) : {};
      final callId = data['callId']?.toString() ?? '';

      _pendingCallDialogs.remove(callId);
      _processedCallIds.remove(callId);

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // If we're in a call screen, go back
      if (Get.currentRoute.contains('VideoCallScreen')) {
        Get.back();
        Get.snackbar("Call Ended", "The call has ended");
      }
    });

    // Listen for host status updates
    socket?.on("host_joined", (raw) {
      debugPrint("🎯 Host joined: $raw");
    });
  }

  // Helper method to reject call
  void _rejectCall(String callId) {
    try {
      debugPrint("❌ Rejecting call: $callId");
      socket?.emit("call_rejected", {
        "callId": callId,
        "hostId": AppUrl.riolive_id.toString(),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint("❌ Error rejecting call: $e");
    }

    _pendingCallDialogs.remove(callId);
    Get.back();
  }

  // Helper method to accept call
  void _acceptCall(String callId, Map<String, dynamic> callData) async {
    try {
      debugPrint("✅ Accepting call: $callId");
      _pendingCallDialogs.remove(callId);
      Get.back();

      final callController = Get.find<CallController>();

      // 1) Join the call via API
      final joinResp = await callController.joinCall(AppUrl.token, callId);
      if (joinResp == null) {
        Get.snackbar("Error", "Failed to join call");
        return;
      }

      // 2) Get channel info - try multiple sources
      final channelName =
          (joinResp['agora']?['channelName'] ??
                  joinResp['call']?['room_id'] ??
                  callData['channel'] ??
                  callData['channelName'] ??
                  callData['roomId'] ??
                  callData['roomName'] ??
                  '')
              .toString();

      if (channelName.isEmpty) {
        Get.snackbar("Error", "No channel name available");
        return;
      }

      // 3) Get token - prefer host token for joiners
      String agoraToken =
          (joinResp['agora']?['hostToken'] ??
                  joinResp['agora']?['token'] ??
                  joinResp['token'] ??
                  '')
              .toString();

      // If no token from join response, fetch one
      if (agoraToken.isEmpty) {
        final uid = int.tryParse(AppUrl.riolive_id.toString()) ?? 0;
        agoraToken =
            await callController.fetchAgoraToken(
              token: AppUrl.token,
              channelName: channelName,
              uid: uid,
              role: 'publisher', // Host acts as publisher in 1-to-1
            ) ??
            '';
      }

      if (agoraToken.isEmpty) {
        Get.snackbar("Error", "Could not get Agora token");
        return;
      }

      // 4) Notify caller that we accepted
      socket?.emit("call_accepted", {
        "callId": callId,
        "hostId": AppUrl.riolive_id.toString(),
        "hostName": AppUrl.user_name ?? "Host",
        "channel": channelName,
        "channelName": channelName,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });

      debugPrint("📤 Emitted call_accepted");

      // 5) Navigate to video call screen
      Get.to(
        () => VideoCallScreen(
          token: AppUrl.token,
          callId: callId,
          channelName: channelName,
          agoraToken: agoraToken,
          isHost: true, // Host accepting the call
        ),
      );
    } catch (e) {
      debugPrint("❌ Error accepting call: $e");
      Get.snackbar("Error", "Failed to accept call: $e");
    }
  }

  // ================= EMITS =================

  /// Caller emits after startCall() succeeds
  void notifyCallStarted(Map<String, dynamic> payload) {
    final enriched = {
      ...payload,
      "callerId": payload["callerId"] ?? payload["userId"],
      "callerName": payload["callerName"] ?? payload["userName"] ?? "Unknown",
      "channel":
          payload["channel"] ??
          payload["channelName"] ??
          payload["roomId"] ??
          payload["roomName"],
      "channelName": payload["channelName"] ?? payload["channel"],
      "roomId": payload["roomId"] ?? payload["channel"],
      "roomName": payload["roomName"] ?? payload["channel"],
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    debugPrint("📤 Emitting call_started: $enriched");
    socket?.emit("call_started", enriched);
  }

  void notifyCallEnded(Map<String, dynamic> payload) {
    final enriched = {
      ...payload,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    debugPrint("📤 Emitting call_ended: $enriched");
    socket?.emit("call_ended", enriched);
  }

  void notifyCallAccepted(Map<String, dynamic> payload) {
    final enriched = {
      ...payload,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    debugPrint("📤 Emitting call_accepted: $enriched");
    socket?.emit("call_accepted", enriched);
  }

  void notifyCallRejected(Map<String, dynamic> payload) {
    final enriched = {
      ...payload,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    debugPrint("📤 Emitting call_rejected: $enriched");
    socket?.emit("call_rejected", enriched);
  }

  /// Host joins live stream
  void hostJoin(String hostId) {
    final payload = {
      "hostId": hostId,
      "userId": AppUrl.riolive_id.toString(),
      "userName": AppUrl.user_name ?? "Host",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    debugPrint("📤 Emitting host_join: $payload");
    socket?.emit("host_join", payload);
  }

  /// Host leaves live stream
  void hostLeave(String hostId) {
    final payload = {
      "hostId": hostId,
      "userId": AppUrl.riolive_id.toString(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    debugPrint("📤 Emitting host_leave: $payload");
    socket?.emit("host_leave", payload);
  }

  // Method to manually clear processed calls (useful for testing)
  void clearProcessedCalls() {
    _processedCallIds.clear();
    _pendingCallDialogs.clear();
    debugPrint("🧹 Cleared processed calls");
  }

  void disposeSocket() {
    debugPrint("🧹 Disposing socket service");
    _pendingCallDialogs.clear();
    _processedCallIds.clear();
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
