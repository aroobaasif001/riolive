import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/controller/random_call_controller.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;

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

    // ================= LISTENERS =================

    /// Host side — Incoming call (payload can contain: callId/id, userName/callerName, channel/channelName/roomId/roomName)
    socket?.off("incoming_call");
    socket?.on("incoming_call", (data) async {
      debugPrint("📲 incoming_call: $data");
      if (Get.isDialogOpen == true) Get.back();

      final callerName = (data['callerName'] ?? data['userName'] ?? 'Unknown')
          .toString();
      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final channelName =
          (data['channel'] ??
                  data['channelName'] ??
                  data['roomId'] ??
                  data['roomName'] ??
                  '')
              .toString();

      if (callId.isEmpty) {
        debugPrint("⚠️ incoming_call missing callId; skipping");
        return;
      }

      Get.dialog(
        AlertDialog(
          title: const Text("Incoming Call"),
          content: Text("User $callerName is calling you."),
          actions: [
            TextButton(
              onPressed: () {
                // optionally notify backend about rejection
                socket?.emit("call_rejected", {"callId": callId});
                Get.back();
              },
              child: const Text("Reject"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();

                final callController = Get.find<CallController>();
                final joinResp = await callController.joinCall(
                  AppUrl.token,
                  callId,
                );

                // Resolve channel
                final resolvedChannel =
                    (joinResp?['agora']?['channelName'] ??
                            channelName ??
                            joinResp?['call']?['room_id'] ??
                            '')
                        .toString();

                // Resolve host token
                String hostToken = (joinResp?['agora']?['hostToken'] ?? '')
                    .toString();
                if (hostToken.isEmpty && resolvedChannel.isNotEmpty) {
                  final uid = int.tryParse(AppUrl.riolive_id.toString()) ?? 0;
                  hostToken =
                      await callController.fetchAgoraToken(
                        token: AppUrl.token,
                        channelName: resolvedChannel,
                        uid: uid,
                        role: 'publisher',
                      ) ??
                      "";
                }

                if (resolvedChannel.isNotEmpty && hostToken.isNotEmpty) {
                  // Notify caller that host accepted (optional; depends on your backend)
                  socket?.emit("call_accepted", {
                    "callId": callId,
                    "channel": resolvedChannel,
                    "channelName": resolvedChannel,
                  });

                  Get.to(
                    () => VideoCallScreen(
                      token: AppUrl.token,
                      callId: callId,
                      channelName: resolvedChannel,
                      agoraToken: hostToken,
                      isHost: true,
                    ),
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Invalid join data (token/channel missing).",
                  );
                }
              },
              child: const Text("Accept"),
            ),
          ],
        ),
      );
    });

    /// Caller side — Host accepted (optional, only if your backend forwards it)
    socket?.off("call_accepted");
    socket?.on("call_accepted", (data) async {
      debugPrint("✅ call_accepted: $data");

      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final channelName =
          (data['channel'] ??
                  data['channelName'] ??
                  data['agora']?['channelName'] ??
                  data['roomId'] ??
                  data['roomName'] ??
                  '')
              .toString();

      String token =
          (data['agora']?['callerToken'] ??
                  data['token'] ??
                  data['agora']?['hostToken'] ??
                  '')
              .toString();

      if (channelName.isEmpty) {
        Get.snackbar("Error", "Missing channel info in call_accepted.");
        return;
      }

      if (token.isEmpty) {
        // Try to fetch a publisher token for caller as well
        final c = Get.find<CallController>();
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

      if (token.isNotEmpty && callId.isNotEmpty) {
        Get.to(
          () => VideoCallScreen(
            token: AppUrl.token,
            callId: callId,
            channelName: channelName,
            agoraToken: token,
            isHost: false,
          ),
        );
      } else {
        Get.snackbar("Error", "Invalid call acceptance data.");
      }
    });

    /// Both sides — Call status updates
    socket?.off("call_status");
    socket?.on("call_status", (data) {
      debugPrint("📡 call_status: $data");
      final status = (data['status'] ?? '').toString();
      if (status == "ended") {
        if (Get.isDialogOpen == true) Get.back();
        Get.snackbar(
          "Call Ended",
          data['message']?.toString() ?? "Call finished",
        );
      } else if (status == "rejected") {
        Get.snackbar(
          "Call Rejected",
          data['message']?.toString() ?? "Host rejected the call",
        );
      }
    });

    /// Host status updates (optional)
    socket?.off("host_status");
    socket?.on("host_status", (data) {
      debugPrint("🟢 host_status: $data");
    });
  }

  // ================= EMITS =================

  /// Use synonym keys so backend can pick any mapping it expects
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

  /// Host goes live — if your backend expects only hostId:
  void hostJoin(String hostId) {
    debugPrint("📤 host_join $hostId");
    socket?.emit("host_join", hostId);
  }

  void disposeSocket() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
