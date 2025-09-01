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

  void initSocket(String token, String userId) {
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
      debugPrint("🔌 Socket connected");
      socket?.emit("authenticate", userId);
    });

    socket?.onDisconnect((_) => debugPrint("❌ Socket disconnected"));

    // ======== LISTENERS ========

    // Broadcast from caller: everyone (or just hosts) receives this
    socket?.off("call_started");
    socket?.on("call_started", (raw) async {
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

    // You can keep your other listeners (incoming_call, call_accepted, call_status, host_status)
    // if you still rely on them elsewhere.
  }

  // ================= EMITS =================

  /// Caller emits after startCall() succeeds
  void notifyCallStarted(Map<String, dynamic> payload) {
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
    debugPrint("📤 call_started $enriched");
    socket?.emit("call_started", enriched);
  }

  void notifyCallEnded(Map<String, dynamic> payload) {
    debugPrint("📤 call_ended $payload");
    socket?.emit("call_ended", payload);
  }

  /// If backend expects only hostId:
  void hostJoin(String hostId) {
    debugPrint("📤 host_join $hostId");
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
}
