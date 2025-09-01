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
    debugPrint("🔌 Initializing socket...");
    debugPrint("🔍 Base URL: ${AppUrl.baseUrl}");
    debugPrint("🔍 Token: ${token.isNotEmpty ? "Present" : "Missing"}");
    debugPrint("🔍 User ID: $userId");
    debugPrint(
      "🔍 Socket instance before: ${socket != null ? "Exists" : "Null"}",
    );
    debugPrint("🔍 Call stack: ${StackTrace.current}");

    // Dispose any existing socket first
    if (socket != null) {
      debugPrint("🔄 Disposing existing socket...");
      socket?.dispose();
      socket = null;
    }

    try {
      debugPrint("🔍 Creating socket.io instance...");
      debugPrint("🔍 Using transports: websocket, polling");

      socket = IO.io(
        AppUrl.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling']) // Add polling as fallback
            .enableForceNew()
            .enableReconnection()
            .setQuery({"token": token})
            .setExtraHeaders({"Origin": AppUrl.baseUrl}) // Add origin header
            .build(),
      );
      debugPrint("✅ Socket instance created successfully");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");

      debugPrint("🔍 Socket connected immediately: ${socket?.connected}");
      debugPrint("🔍 Socket ID immediately: ${socket?.id}");
    } catch (e) {
      debugPrint("❌ Error creating socket: $e");
      debugPrint("❌ Stack trace: ${StackTrace.current}");
      return;
    }

    socket?.onConnect((_) {
      debugPrint("✅ Socket connected successfully!");
      debugPrint("🔍 Socket ID: ${socket?.id}");
      debugPrint("🔍 Socket connected: ${socket?.connected}");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
      socket?.emit("authenticate", int.parse(userId));
      debugPrint("📤 Sent authenticate event with userId: $userId");
    });

    socket?.onDisconnect((_) {
      debugPrint("❌ Socket disconnected");
      debugPrint("🔍 Socket ID: ${socket?.id}");
      debugPrint("🔍 Socket connected: ${socket?.connected}");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
    });

    socket?.onConnectError((error) {
      debugPrint("❌ Socket connection error: $error");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");

      // If WebSocket fails, try to force polling transport
      if (error.toString().contains("websocket") ||
          error.toString().contains("404")) {
        debugPrint(
          "🔄 WebSocket failed, attempting to use polling transport...",
        );
        try {
          socket?.disconnect();
          socket = IO.io(
            AppUrl.baseUrl,
            IO.OptionBuilder()
                .setTransports(['polling']) // Force polling only
                .enableForceNew()
                .enableReconnection()
                .setQuery({"token": token})
                .setExtraHeaders({"Origin": AppUrl.baseUrl})
                .build(),
          );
          debugPrint("✅ Recreated socket with polling transport");
        } catch (e) {
          debugPrint("❌ Failed to recreate socket with polling: $e");
        }
      }
    });

    socket?.onError((error) {
      debugPrint("❌ Socket error: $error");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
    });

    // Add timeout to check connection status
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint("⏰ Socket connection check after 3 seconds:");
      debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
      debugPrint("🔍 Socket connected: ${socket?.connected}");
      debugPrint("🔍 Socket ID: ${socket?.id}");
      if (socket?.connected != true) {
        debugPrint("⚠️ Socket still not connected after 3 seconds!");
      }
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
      debugPrint("🔔 Received call_started event: $raw");
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final callerName = (data['callerName'] ?? data['userName'] ?? 'Unknown')
          .toString();

      if (callId.isEmpty) {
        debugPrint("⚠️ call_started without callId");
        return;
      }

      // Ignore self
      final callerId = (data['callerId'] ?? data['userId'] ?? '').toString();
      if (callerId == AppUrl.riolive_id.toString()) return;

      // (Optional) If only HOSTS should see this dialog, uncomment:
      // if (AppUrl.user_role?.toLowerCase() != 'host') return;

      if (_pendingCallDialogs.contains(callId)) return;
      _pendingCallDialogs.add(callId);

      if (Get.isDialogOpen == true) Get.back();

      Get.dialog(
        AlertDialog(
          title: const Text("Incoming Call"),
          content: Text("User $callerName is calling you."),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  socket?.emit("call_rejected", {"callId": callId});
                } catch (_) {}
                _pendingCallDialogs.remove(callId);
                Get.back();
              },
              child: const Text("Reject"),
            ),
            TextButton(
              onPressed: () async {
                _pendingCallDialogs.remove(callId);
                Get.back();

                final c = Get.find<CallController>();

                // 1) Join API via callId
                final joinResp = await c.joinCall(AppUrl.token, callId);
                if (joinResp == null) {
                  Get.snackbar("Error", "Join call failed.");
                  return;
                }

                // 2) Resolve channel name
                final channelName =
                    (joinResp['agora']?['channelName'] ??
                            joinResp['call']?['room_id'] ??
                            data['channel'] ??
                            data['channelName'] ??
                            data['roomId'] ??
                            data['roomName'] ??
                            '')
                        .toString();

                // 3) Resolve token
                String token =
                    (joinResp['agora']?['hostToken'] ??
                            joinResp['agora']?['token'] ??
                            joinResp['token'] ??
                            data['agora']?['token'] ??
                            '')
                        .toString();

                if (token.isEmpty && channelName.isNotEmpty) {
                  final uid = int.tryParse(AppUrl.riolive_id.toString()) ?? 0;
                  token =
                      await c.fetchAgoraToken(
                        token: AppUrl.token,
                        channelName: channelName,
                        uid: uid,
                        role: 'publisher',
                      ) ??
                      "";
                }

                if (channelName.isEmpty || token.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Invalid join data (token/channel missing).",
                  );
                  return;
                }

                // 4) Notify caller accepted (optional UI sync)
                try {
                  socket?.emit("call_accepted", {
                    "callId": callId,
                    "channel": channelName,
                    "channelName": channelName,
                    "agora": {"token": token},
                  });
                } catch (_) {}

                // 5) Open the call as host/broadcaster
                Get.to(
                  () => VideoCallScreen(
                    token: AppUrl.token,
                    callId: callId,
                    channelName: channelName,
                    agoraToken: token,
                    isHost: true,
                  ),
                );
              },
              child: const Text("Accept"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });

    // Live stream notification listener
    socket?.off("host_joined_live");
    socket?.on("host_joined_live", (raw) async {
      debugPrint("🔔 Received host_joined_live event: $raw");
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final hostId = (data['hostId'] ?? data['id'] ?? '').toString();
      final hostName = (data['hostName'] ?? data['userName'] ?? 'Unknown Host')
          .toString();

      if (hostId.isEmpty) {
        debugPrint("⚠️ host_joined_live without hostId");
        return;
      }

      // Ignore self
      final callerId = (data['hostId'] ?? data['userId'] ?? '').toString();
      if (callerId == AppUrl.riolive_id.toString()) {
        debugPrint("🚫 Ignoring own live stream notification");
        return;
      }

      debugPrint("🎯 Showing live stream notification for host: $hostName");

      if (_pendingCallDialogs.contains(hostId)) return;
      _pendingCallDialogs.add(hostId);

      if (Get.isDialogOpen == true) Get.back();

      Get.dialog(
        AlertDialog(
          title: const Text("Live Stream Started"),
          content: Text("$hostName has started a live stream!"),
          actions: [
            TextButton(
              onPressed: () {
                _pendingCallDialogs.remove(hostId);
                Get.back();
              },
              child: const Text("Dismiss"),
            ),
            TextButton(
              onPressed: () async {
                _pendingCallDialogs.remove(hostId);
                Get.back();

                final c = Get.find<CallController>();

                // Get live hosts to find the specific host
                final liveHosts = await c.getLiveHosts(AppUrl.token);
                final targetHost = liveHosts.firstWhere(
                  (host) => host['id'].toString() == hostId,
                  orElse: () => {},
                );

                if (targetHost.isEmpty) {
                  Get.snackbar("Error", "Live stream not found.");
                  return;
                }

                // Note: The live hosts API doesn't return room_id, so we'll use the hostId as roomId
                // This is a workaround - ideally the API should return room_id for live hosts
                final roomId = targetHost['id']?.toString() ?? "";
                if (roomId.isEmpty) {
                  Get.snackbar("Error", "Invalid live stream data.");
                  return;
                }

                // Join the live stream as audience
                final joinResp = await c.joinCall(AppUrl.token, roomId);
                if (joinResp == null) {
                  Get.snackbar("Error", "Join live stream failed.");
                  return;
                }

                final channelName =
                    (joinResp['agora']?['channelName'] ??
                            joinResp['call']?['room_id'] ??
                            roomId)
                        .toString();
                final token =
                    (joinResp['agora']?['token'] ?? joinResp['token'] ?? "")
                        .toString();

                if (channelName.isEmpty || token.isEmpty) {
                  Get.snackbar("Error", "Invalid join data.");
                  return;
                }

                // Open the live stream as audience
                Get.to(
                  () => VideoCallScreen(
                    token: AppUrl.token,
                    callId: roomId,
                    channelName: channelName,
                    agoraToken: token,
                    isHost: false, // Join as audience
                  ),
                );
              },
              child: const Text("Join"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });

    // You can keep your other listeners (incoming_call, call_accepted, call_status, host_status)
    // if you still rely on them elsewhere.
  }

  // ================= EMITS =================

  /// Caller emits after startCall() succeeds
  void notifyCallStarted(Map<String, dynamic> payload) {
    debugPrint("🔔 notifyCallStarted() called with payload: $payload");

    final enriched = {
      ...payload,
      "callerId": payload["callerId"] ?? payload["userId"],
      "callerName": payload["callerName"] ?? payload["userName"],
      "channel":
          payload["channel"] ??
          payload["channelName"] ??
          payload["roomId"] ??
          payload["roomName"],
      "channelName": payload["channelName"] ?? payload["channel"],
      "roomId": payload["roomId"] ?? payload["channel"],
      "roomName": payload["roomName"] ?? payload["channel"],
    };

    debugPrint("🔍 Socket connection status: ${socket?.connected}");
    debugPrint("🔍 Socket ID: ${socket?.id}");
    debugPrint("📤 Emitting call_started with enriched payload: $enriched");

    if (socket?.connected == true) {
      socket?.emit("call_started", enriched);
      debugPrint("✅ call_started event emitted successfully");
    } else {
      debugPrint("❌ Socket not connected - cannot emit call_started event");
      debugPrint("🔍 Socket state: ${socket?.connected}");
    }
  }

  void notifyCallEnded(Map<String, dynamic> payload) {
    debugPrint("📤 call_ended $payload");
    socket?.emit("call_ended", payload);
  }

  /// If backend expects only hostId:
  void hostJoin(String hostId) {
    debugPrint("📤 host_join $hostId");
    debugPrint("🔍 Emitting host_join event with hostId: $hostId");
    debugPrint("🔍 Current user ID: ${AppUrl.riolive_id}");
    debugPrint("🔍 Current user name: ${AppUrl.user_name}");
    socket?.emit("host_join", hostId);
  }

  // Optional: payload variant
  // void hostJoinWithPayload(Map<String, dynamic> payload) {
  //   debugPrint("📤 host_join(payload) $payload");
  //   socket?.emit("host_join", payload);
  // }

  void disposeSocket() {
    _pendingCallDialogs.clear();
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }

  // Debug method to check socket status
  void debugSocketStatus() {
    debugPrint("🔍 === SOCKET STATUS DEBUG ===");
    debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
    debugPrint("🔍 Socket connected: ${socket?.connected}");
    debugPrint("🔍 Socket ID: ${socket?.id}");
    debugPrint("🔍 Base URL: ${AppUrl.baseUrl}");
    debugPrint("🔍 ============================");
  }

  // Force socket reconnection
  void forceReconnect(String token, String userId) {
    debugPrint("🔄 Force reconnecting socket...");
    disposeSocket();
    Future.delayed(const Duration(milliseconds: 500), () {
      initSocket(token, userId);
    });
  }
}
