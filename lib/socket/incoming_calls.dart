import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/controller/random_call_controller.dart';
import 'package:riolive/utile/app_url.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/call_screen/video_call_screen/video_call_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  // De-dupe dialogs per callId
  final Set<String> _pendingCallDialogs = {};
  final Set<String> _processedCallIds = {};

  // Connection state management
  final RxBool isConnected = false.obs;
  final RxString connectionStatus = 'disconnected'.obs;

  @override
  void onClose() {
    disposeSocket();
    super.onClose();
  }

  void initSocket(String token, String userId) {
    if (_isConnecting || socket?.connected == true) {
      debugPrint("⚠️ Socket already connected or connecting");
      return;
    }

    debugPrint("🔌 Initializing socket for user: $userId");
    connectionStatus.value = 'connecting';
    _isConnecting = true;

    // Dispose any existing socket first
    disposeSocket();

    try {
      socket = IO.io(
        AppUrl.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableForceNew()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(20000)
            .setQuery({"token": token, "userId": userId})
            .setExtraHeaders({
              "Origin": AppUrl.baseUrl,
              "User-Agent": "Riolive-App",
            })
            .build(),
      );

      _setupEventListeners(userId);

      // Force connection
      socket?.connect();
    } catch (e) {
      debugPrint("❌ Error creating socket: $e");
      connectionStatus.value = 'error';
      _isConnecting = false;
    }
  }

  void _setupEventListeners(String userId) {
    if (socket == null) return;

    // Connection events
    socket?.onConnect((_) {
      debugPrint("✅ Socket connected successfully!");
      debugPrint("🔍 Socket ID: ${socket?.id}");
      isConnected.value = true;
      connectionStatus.value = 'connected';
      _isConnecting = false;
      _reconnectAttempts = 0;

      // Authenticate with server
      socket?.emit("authenticate", {
        "userId": userId,
        "userName": AppUrl.user_name,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    });

    socket?.onDisconnect((_) {
      debugPrint("❌ Socket disconnected");
      isConnected.value = false;
      connectionStatus.value = 'disconnected';
      _isConnecting = false;
    });

    socket?.onConnectError((error) {
      debugPrint("❌ Socket connection error: $error");
      connectionStatus.value = 'error';
      _isConnecting = false;

      if (_reconnectAttempts < _maxReconnectAttempts) {
        _reconnectAttempts++;
        debugPrint(
          "🔄 Reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts",
        );
      }
    });

    socket?.onError((error) {
      debugPrint("❌ Socket error: $error");
      connectionStatus.value = 'error';
    });

    socket?.onReconnect((attempt) {
      debugPrint("🔄 Socket reconnected after $attempt attempts");
      _reconnectAttempts = 0;
    });

    socket?.onReconnectError((error) {
      debugPrint("❌ Socket reconnect error: $error");
    });

    // Application-specific events
    _setupApplicationListeners();
  }

  void _setupApplicationListeners() {
    // Clear existing listeners to avoid duplicates
    socket?.off("call_started");
    socket?.off("call_accepted");
    socket?.off("call_rejected");
    socket?.off("call_ended");
    socket?.off("host_joined");
    socket?.off("host_joined_live");

    // Listen for incoming calls
    socket?.on("call_started", (raw) async {
      debugPrint("🔔 Received call_started event: $raw");
      _handleIncomingCall(raw);
    });

    // Listen for live stream notifications
    socket?.on("host_joined_live", (raw) async {
      debugPrint("🔔 Received host_joined_live event: $raw");
      _handleLiveStreamNotification(raw);
    });

    // Add other event listeners as needed
    socket?.on("call_accepted", (data) {
      debugPrint("✅ Call accepted: $data");
    });

    socket?.on("call_rejected", (data) {
      debugPrint("❌ Call rejected: $data");
    });

    socket?.on("call_ended", (data) {
      debugPrint("📞 Call ended: $data");
    });
  }

  void _handleIncomingCall(dynamic raw) async {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final callerName = (data['callerName'] ?? data['userName'] ?? 'Unknown')
          .toString();
      final callerId = (data['callerId'] ?? data['userId'] ?? '').toString();

      if (callId.isEmpty) {
        debugPrint("⚠️ call_started without callId");
        return;
      }

      // Ignore self calls
      if (callerId == AppUrl.riolive_id.toString()) {
        debugPrint("🚫 Ignoring self call");
        return;
      }

      // Prevent duplicate dialogs
      if (_pendingCallDialogs.contains(callId)) return;
      _pendingCallDialogs.add(callId);

      // Close any existing dialogs
      if (Get.isDialogOpen == true) Get.back();

      // Show incoming call dialog
      Get.dialog(
        _buildIncomingCallDialog(callId, callerName, data),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint("❌ Error handling incoming call: $e");
    }
  }

  Widget _buildIncomingCallDialog(
    String callId,
    String callerName,
    Map<String, dynamic> data,
  ) {
    return AlertDialog(
      title: const Text("📞 Incoming Call"),
      content: Text("$callerName is calling you."),
      actions: [
        TextButton(
          onPressed: () {
            _rejectCall(callId);
            Get.back();
          },
          child: const Text("Reject", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            _acceptCall(callId, data);
          },
          child: const Text("Accept", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  void _rejectCall(String callId) {
    try {
      socket?.emit("call_rejected", {
        "callId": callId,
        "userId": AppUrl.riolive_id,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint("❌ Error rejecting call: $e");
    } finally {
      _pendingCallDialogs.remove(callId);
    }
  }

  void _acceptCall(String callId, Map<String, dynamic> data) async {
    try {
      final c = Get.find<CallController>();

      // Join the call
      final joinResp = await c.joinCall(AppUrl.token, callId);
      if (joinResp == null) {
        Get.snackbar("Error", "Failed to join call");
        return;
      }

      // Extract channel and token information
      final channelName = _extractChannelName(joinResp, data);
      final token = _extractToken(joinResp, data);

      if (channelName.isEmpty || token.isEmpty) {
        Get.snackbar("Error", "Invalid call data received");
        return;
      }

      // Notify caller that call was accepted
      socket?.emit("call_accepted", {
        "callId": callId,
        "userId": AppUrl.riolive_id,
        "userName": AppUrl.user_name,
        "channelName": channelName,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });

      // Navigate to video call screen
      Get.to(
        () => VideoCallScreen(
          token: AppUrl.token,
          callId: callId,
          channelName: channelName,
          agoraToken: token,
          isHost: true,
        ),
      );
    } catch (e) {
      debugPrint("❌ Error accepting call: $e");
      Get.snackbar("Error", "Failed to accept call: $e");
    } finally {
      _pendingCallDialogs.remove(callId);
    }
  }

  String _extractChannelName(
    Map<String, dynamic> joinResp,
    Map<String, dynamic> originalData,
  ) {
    return (joinResp['agora']?['channelName'] ??
            joinResp['call']?['room_id'] ??
            originalData['channelName'] ??
            originalData['channel'] ??
            originalData['roomId'] ??
            '')
        .toString();
  }

  String _extractToken(
    Map<String, dynamic> joinResp,
    Map<String, dynamic> originalData,
  ) {
    return (joinResp['agora']?['hostToken'] ??
            joinResp['agora']?['token'] ??
            joinResp['token'] ??
            originalData['agora']?['token'] ??
            originalData['token'] ??
            '')
        .toString();
  }

  void _handleLiveStreamNotification(dynamic raw) {
    // Similar implementation for live stream notifications
    // You can adapt the pattern from _handleIncomingCall
  }

  // ================= EMIT METHODS =================

  void notifyCallStarted(Map<String, dynamic> payload) {
    if (!isConnected.value) {
      debugPrint("❌ Socket not connected - cannot emit call_started");
      _attemptReconnectionThenEmit("call_started", payload);
      return;
    }

    try {
      final enrichedPayload = {
        ...payload,
        "callerId": AppUrl.riolive_id,
        "callerName": AppUrl.user_name ?? "Unknown User",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "device": "mobile",
      };

      debugPrint("📤 Emitting call_started: $enrichedPayload");
      socket?.emit("call_started", enrichedPayload);
    } catch (e) {
      debugPrint("❌ Error emitting call_started: $e");
    }
  }

  void _attemptReconnectionThenEmit(String event, dynamic data) {
    debugPrint("🔄 Attempting reconnection before emitting $event");

    if (!_isConnecting) {
      initSocket(AppUrl.token, AppUrl.riolive_id.toString());
    }

    // Wait a bit and try again
    Future.delayed(const Duration(seconds: 2), () {
      if (isConnected.value) {
        socket?.emit(event, data);
      } else {
        debugPrint("❌ Still not connected after reconnection attempt");
      }
    });
  }

  void notifyCallEnded(Map<String, dynamic> payload) {
    if (!isConnected.value) return;

    try {
      socket?.emit("call_ended", {
        ...payload,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint("❌ Error emitting call_ended: $e");
    }
  }

  void hostJoin(String hostId) {
    if (!isConnected.value) return;

    try {
      socket?.emit("host_join", {
        "hostId": hostId,
        "userId": AppUrl.riolive_id,
        "userName": AppUrl.user_name,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint("❌ Error emitting host_join: $e");
    }
  }

  void disposeSocket() {
    _pendingCallDialogs.clear();
    _isConnecting = false;

    if (socket != null) {
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }

    isConnected.value = false;
    connectionStatus.value = 'disconnected';
  }

  // Debug and utility methods
  void debugSocketStatus() {
    debugPrint("🔍 === SOCKET STATUS ===");
    debugPrint("🔍 Connected: ${isConnected.value}");
    debugPrint("🔍 Status: ${connectionStatus.value}");
    debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
    debugPrint("🔍 Socket ID: ${socket?.id}");
    debugPrint("🔍 Reconnect attempts: $_reconnectAttempts");
    debugPrint("🔍 =====================");
  }

  void forceReconnect(String token, String userId) {
    debugPrint("🔄 Force reconnecting socket...");
    disposeSocket();
    Future.delayed(const Duration(milliseconds: 500), () {
      initSocket(token, userId);
    });
  }

  // Check if socket is properly connected
  bool get isSocketReady => isConnected.value && socket != null;
}
