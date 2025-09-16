import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  final Set<String> _pendingCallDialogs = {};

  final RxBool isConnected = false.obs;
  final RxString connectionStatus = 'disconnected'.obs;
  
  // Host room management
  String? currentHostRoom;
  
  // Call management for multiple hosts
  final RxnString currentIncomingCallId = RxnString();
  final RxBool isShowingCallDialog = false.obs;
  
  /// Wait for socket connection with timeout
  Future<bool> waitForConnection({int timeoutSeconds = 10}) async {
    debugPrint("⏳ Waiting for socket connection... Current status: ${connectionStatus.value}, IsConnected: ${isConnected.value}");
    
    if (isConnected.value) {
      debugPrint("✅ Socket already connected");
      return true;
    }
    
    // If socket is not even initialized, try to initialize it
    if (socket == null && !_isConnecting) {
      debugPrint("🔄 Socket not initialized - attempting to initialize...");
      
      if (AppUrl.token.isNotEmpty && AppUrl.riolive_id != null) {
        initSocket(AppUrl.token, AppUrl.riolive_id.toString());
        // Give it a moment to start connecting
        await Future.delayed(Duration(milliseconds: 500));
      } else {
        debugPrint("❌ Cannot initialize socket - Token or UserId missing");
        debugPrint("📋 Token: ${AppUrl.token.isNotEmpty ? 'Present' : 'Missing'}");
        debugPrint("📋 UserId: ${AppUrl.riolive_id}");
        return false;
      }
    }
    
    final completer = Completer<bool>();
    Timer? timeout;
    
    // Listen for connection
    final subscription = isConnected.listen((connected) {
      if (connected) {
        debugPrint("✅ Socket connected successfully during wait");
        timeout?.cancel();
        if (!completer.isCompleted) completer.complete(true);
      }
    });
    
    // Set timeout
    timeout = Timer(Duration(seconds: timeoutSeconds), () {
      debugPrint("⏰ Socket connection timeout after ${timeoutSeconds}s - Final status: ${connectionStatus.value}");
      subscription.cancel();
      if (!completer.isCompleted) completer.complete(false);
    });
    
    final result = await completer.future;
    subscription.cancel();
    timeout.cancel();
    
    return result;
  }

  /// Public method to test host setup (can be called from UI)
  void debugHostSetup() => testHostSetup();
  
  /// Public method to setup host for calls ONLY when they go live
  Future<void> setupHostForCalls() async {
    if (AppUrl.user_role != "host") {
      debugPrint("❌ Only hosts can be set up for calls");
      return;
    }
    
    if (!isConnected.value) {
      debugPrint("❌ Socket not connected - cannot setup host");
      return;
    }
    
    debugPrint("🔴 Host going LIVE - setting up for incoming calls...");
    await _setupHostRoom(AppUrl.riolive_id.toString());
  }
  
  /// Public method to remove host from calls when they go offline
  Future<void> removeHostFromCalls() async {
    if (AppUrl.user_role != "host") return;
    
    debugPrint("⚫ Host going OFFLINE - removing from calls...");
    
    try {
      // Set host as offline
      if (currentHostRoom != null) {
        await _setHostLiveStatus(false, currentHostRoom!);
        leaveHostRoom();
      }
    } catch (e) {
      debugPrint("❌ Error removing host from calls: $e");
    }
  }
  
  /// Force reconnect socket (useful for network recovery)
  Future<bool> forceReconnect({int timeoutSeconds = 15}) async {
    try {
      debugPrint("🔄 Force reconnecting socket...");
      
      // Dispose current connection
      disposeSocket();
      await Future.delayed(Duration(seconds: 1));
      
      // Reinitialize
      if (AppUrl.token.isNotEmpty && AppUrl.riolive_id != null) {
        initSocket(AppUrl.token, AppUrl.riolive_id.toString());
        return await waitForConnection(timeoutSeconds: timeoutSeconds);
      }
      
    } catch (e) {
      debugPrint("❌ Force reconnect failed: $e");
    }
    
    return false;
  }

  @override
  void onClose() {
    leaveHostRoom();
    disposeSocket();
    super.onClose();
  }

  void initSocket(String token, String userId) {
    debugPrint("🔌 InitSocket called - Token: ${token.isNotEmpty ? 'Present' : 'Missing'}, UserId: $userId, Role: ${AppUrl.user_role}");
    debugPrint("🔌 Current connection state - IsConnected: ${isConnected.value}, IsConnecting: $_isConnecting, Socket: ${socket?.connected}");
    
    if (token.isEmpty) {
      debugPrint("❌ Cannot init socket - Token is empty");
      return;
    }
    
    if (userId.toString().isEmpty) {
      debugPrint("❌ Cannot init socket - UserId is empty");
      return;
    }
    
    if (_isConnecting || socket?.connected == true) {
      debugPrint("⚠ Socket already connected or connecting - IsConnecting: $_isConnecting, SocketConnected: ${socket?.connected}");
      return;
    }

    debugPrint("🔌 Initializing socket for user: $userId, Role: ${AppUrl.user_role}");
    connectionStatus.value = 'connecting';
    _isConnecting = true;

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
            .setQuery({"token": token})  // ✅ Match JS implementation
            .setExtraHeaders({
              "Origin": AppUrl.baseUrl,
              "User-Agent": "Riolive-App",
            })
            .build(),
      );

      _setupEventListeners(userId);

      socket?.connect();
    } catch (e) {
      debugPrint("❌ Error creating socket: $e");
      connectionStatus.value = 'error';
      _isConnecting = false;
    }
  }

  void _setupEventListeners(String userId) {
    if (socket == null) return;

    socket?.onConnect((_) {
      debugPrint("✅ Socket connected successfully!");
      debugPrint("🔍 Socket ID: ${socket?.id}");
      isConnected.value = true;
      connectionStatus.value = 'connected';
      _isConnecting = false;
      _reconnectAttempts = 0;

      debugPrint("🔐 Connected with query token - UserId: $userId, Role: ${AppUrl.user_role}");
      
      // ✅ Send authenticate event like JS implementation
      socket?.emit("authenticate", {"token": AppUrl.token});
      debugPrint("🔐 Sent authenticate event to backend");
      
      // If user is a host, just log - don't auto-join room until live streaming starts
      if (AppUrl.user_role == "host") {
        debugPrint("👑 User is HOST - waiting for live streaming to start...");
        debugPrint("🔔 Host will only receive calls when actively live streaming");
      } else {
        debugPrint("👤 User is not HOST - Role: ${AppUrl.user_role}");
      }
    });

    socket?.onDisconnect((reason) {
      debugPrint("❌ Socket disconnected - Reason: $reason");
      debugPrint("❌ Disconnect details: ${socket?.disconnected}, ID: ${socket?.id}");
      isConnected.value = false;
      connectionStatus.value = 'disconnected';
      _isConnecting = false;
      
      // Set host offline if they were online
      if (AppUrl.user_role == "host" && currentHostRoom != null) {
        _setHostLiveStatus(false, currentHostRoom!);
      }
      
      // Clear host room on disconnect
      currentHostRoom = null;
    });

    socket?.onConnectError((error) {
      debugPrint("❌ Socket connection error: $error");
      connectionStatus.value = 'error';
      _isConnecting = false;

      // Check if it's a network/DNS error
      if (error.toString().contains('Failed host lookup') || 
          error.toString().contains('No address associated with hostname')) {
        debugPrint("🌐 Network/DNS error detected - will retry with delay");
        // Wait longer for network issues
        Future.delayed(Duration(seconds: 10), () {
          if (_reconnectAttempts < _maxReconnectAttempts && !isConnected.value) {
        _reconnectAttempts++;
            debugPrint("🔄 Network retry attempt $_reconnectAttempts/$_maxReconnectAttempts");
            socket?.connect();
          }
        });
      } else if (_reconnectAttempts < _maxReconnectAttempts) {
        _reconnectAttempts++;
        debugPrint("🔄 Reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts");
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

    // Listen for room join confirmations
    socket?.on("room_joined", (data) {
      debugPrint("✅ Room join confirmed by backend: $data");
    });
    
    socket?.on("room_join_error", (data) {
      debugPrint("❌ Room join error from backend: $data");
    });
    
    // Listen for host status updates
    socket?.on("host_status_updated", (data) {
      debugPrint("👑 Host status updated by backend: $data");
    });
    
    // Listen for authentication response from backend
    socket?.on("authenticated", (data) {
      debugPrint("✅ Backend authentication successful: $data");
    });
    
    socket?.on("auth_error", (data) {
      debugPrint("❌ Backend authentication failed: $data");
    });

    _setupApplicationListeners();
  }

  void _setupApplicationListeners() {
    socket?.off("incoming_call");
    socket?.off("call_status");
    socket?.off("host_status");
    socket?.off("call_started");
    socket?.off("call_accepted");
    socket?.off("call_rejected");
    socket?.off("call_ended");
    socket?.off("host_joined_live");

    // 🔔 Backend: incoming call
    socket?.on("incoming_call", (raw) async {
      debugPrint("🚨 ==========================================");
      debugPrint("🚨 INCOMING CALL EVENT RECEIVED!");
      debugPrint("🚨 Raw data: $raw");
      debugPrint("🚨 Data type: ${raw.runtimeType}");
      debugPrint("🚨 Current host room: $currentHostRoom");
      debugPrint("🚨 Host role: ${AppUrl.user_role}");
      debugPrint("🚨 Host ID: ${AppUrl.riolive_id}");
      debugPrint("🚨 Socket ID: ${socket?.id}");
      debugPrint("🚨 Socket connected: ${isConnected.value}");
      debugPrint("🚨 ==========================================");
      
      _handleIncomingCall(raw);
    });

    // 🔔 Frontend/client side: call started (agar backend isko broadcast karta hai)
    socket?.on("call_started", (raw) async {
      debugPrint("🔔 Received call_started event: $raw");
      _handleIncomingCall(raw);
    });

    // 🔔 Backend: call status updates (active/ended)
    socket?.on("call_status", (data) {
      debugPrint("📞 Call status update: $data");
      _handleCallStatusUpdate(data);
    });
    
    // 🔔 Enhanced: call ended by either party
    socket?.on("call_ended", (data) {
      debugPrint("🔚 Call ended event received: $data");
      _handleCallEnded(data);
    });
    
    // 🔔 Backend: call accepted by another host
    socket?.on("call_accepted", (data) {
      debugPrint("✅ Call accepted by another host: $data");
      _handleCallAcceptedByOther(data);
    });
    
    // 🔔 Backend: call rejected by host
    socket?.on("call_rejected", (data) {
      debugPrint("❌ Call rejected by host: $data");
      _handleCallRejected(data);
    });

    // 🔔 Backend: host online/offline
    socket?.on("host_status", (data) {
      debugPrint("👤 Host status update: $data");
    });

    // ================== PRIVATE CALL EVENTS ==================
    
    // 📞 Private call request received (for hosts)
    socket?.on("private_call_request", (data) {
      debugPrint("📞 Private call request received: $data");
      _handlePrivateCallRequest(data);
    });
    
    // ✅ Private call accepted (for users)
    socket?.on("private_call_accepted", (data) {
      debugPrint("✅ 🎉🎉🎉 PRIVATE CALL ACCEPTED EVENT RECEIVED! 🎉🎉🎉");
      debugPrint("✅ Raw event data: $data");
      debugPrint("✅ Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("✅ Current route: ${Get.currentRoute}");
      debugPrint("✅ Socket ID: ${socket?.id}");
      _handlePrivateCallAccepted(data);
    });
    
    // ❌ Private call rejected (for users)
    socket?.on("private_call_rejected", (data) {
      debugPrint("❌ 🚫🚫🚫 PRIVATE CALL REJECTED EVENT RECEIVED! 🚫🚫🚫");
      debugPrint("❌ Raw event data: $data");
      debugPrint("❌ Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      _handlePrivateCallRejected(data);
    });
    
    // 🔚 Private call ended
    socket?.on("private_call_ended", (data) {
      debugPrint("🔚 Private call ended: $data");
      _handlePrivateCallEnded(data);
    });

    // 🔧 TEMPORARY FIX: Listen to private_call_status as backup
    socket?.on("private_call_status", (data) {
      debugPrint("📊 ===========================================");
      debugPrint("📊 PRIVATE CALL STATUS EVENT RECEIVED!");
      debugPrint("📊 Raw event data: $data");
      debugPrint("📊 Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("📊 ===========================================");
      
      // Check if this is actually an "accepted" status for current user
      final Map<String, dynamic> eventData = data is Map ? Map<String, dynamic>.from(data) : {};
      final status = eventData['status']?.toString() ?? '';
      final requesterId = eventData['requesterId']?.toString() ?? '';
      final hostId = eventData['hostId']?.toString() ?? '';
      
      debugPrint("🔍 Checking relevance:");
      debugPrint("🔍 - Status: $status");
      debugPrint("🔍 - Requester ID: $requesterId");
      debugPrint("🔍 - Host ID: $hostId");
      debugPrint("🔍 - Current User ID: ${AppUrl.riolive_id}");
      debugPrint("🔍 - Current User Role: ${AppUrl.user_role}");
      
      bool isRelevantForUser = false;
      String relevanceReason = '';
      
      // Check multiple conditions for relevance
      if (status == 'active' || status == 'accepted') {
        // Method 1: Direct requester ID match
        if (requesterId == AppUrl.riolive_id.toString()) {
          isRelevantForUser = true;
          relevanceReason = 'Direct requester ID match';
        }
        // Method 2: If user is not a host and status is active (likely for the user)
        else if (AppUrl.user_role != 'host' && (status == 'active' || status == 'accepted')) {
          isRelevantForUser = true;
          relevanceReason = 'User role match - non-host receiving active status';
        }
        // Method 3: Check if this is a private call the user initiated (based on current context)
        else if (AppUrl.user_role == 'user' && status == 'active') {
          isRelevantForUser = true;
          relevanceReason = 'User role and active status - assuming user initiated this call';
        }
      }
      // ✅ NEW: Handle call ended status
      else if (status == 'ended') {
        // Check if user was involved in this call
        if (requesterId == AppUrl.riolive_id.toString() || hostId == AppUrl.riolive_id.toString()) {
          isRelevantForUser = true;
          relevanceReason = 'User involved in ended call';
        }
      }
      // ✅ NEW: Handle call rejected status
      else if (status == 'rejected') {
        // Check if user was the one who requested this call
        if (requesterId == AppUrl.riolive_id.toString()) {
          isRelevantForUser = true;
          relevanceReason = 'User is the one who requested this rejected call (ID match)';
        }
        // ✅ FALLBACK: If user is not a host and receives rejection, likely for them
        else if (AppUrl.user_role != 'host' && AppUrl.user_role == 'user') {
          isRelevantForUser = true;
          relevanceReason = 'User role - non-host receiving rejection event (likely intended for this user)';
        }
      }
      
      debugPrint("🔍 Is relevant for user: $isRelevantForUser");
      debugPrint("🔍 Relevance reason: $relevanceReason");
      
      if (isRelevantForUser) {
        if (status == 'ended') {
          debugPrint("🔚 ==========================================");
          debugPrint("🔚 TREATING private_call_status AS ENDED!");
          debugPrint("🔚 Reason: $relevanceReason");
          debugPrint("🔚 Status: $status");
          debugPrint("🔚 Processing as private_call_ended event...");
          debugPrint("🔚 ==========================================");
          _handlePrivateCallEndedByOther(data);
        } else if (status == 'rejected') {
          debugPrint("❌ ==========================================");
          debugPrint("❌ TREATING private_call_status AS REJECTED!");
          debugPrint("❌ Reason: $relevanceReason");
          debugPrint("❌ Status: $status");
          debugPrint("❌ Processing as private_call_rejected event...");
          debugPrint("❌ ==========================================");
          _handlePrivateCallRejected(data);
        } else {
          debugPrint("🔧 ==========================================");
          debugPrint("🔧 TREATING private_call_status AS ACCEPTED!");
          debugPrint("🔧 Reason: $relevanceReason");
          debugPrint("🔧 Status: $status");
          debugPrint("🔧 Processing as private_call_accepted event...");
          debugPrint("🔧 ==========================================");
          _handlePrivateCallAccepted(data);
        }
      } else {
        debugPrint("📊 private_call_status not relevant for current user");
        debugPrint("📊 Reason: No matching conditions met");
      }
    });

    // 🔍 DEBUG: Listen to ALL events to debug missing events
    socket?.onAny((event, data) {
      if (event.toString().contains('private') || 
          event.toString().contains('call') ||
          event.toString().contains('accepted') ||
          event.toString().contains('rejected')) {
        debugPrint("🔍 ===========================================");
        debugPrint("🔍 DEBUG: SOCKET EVENT RECEIVED");
        debugPrint("🔍 Event Name: '$event'");
        debugPrint("🔍 Event Data: $data");
        debugPrint("🔍 Current User: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
        debugPrint("🔍 Socket ID: ${socket?.id}");
        debugPrint("🔍 Is Connected: ${isConnected.value}");
        debugPrint("🔍 ===========================================");
      }
    });

    // ================== LIVE STREAM EVENTS ==================
    
    // Host joins live streaming  
    socket?.on("host_joined_live", (raw) async {
      debugPrint("🔴 Host joined live: $raw");
      _handleLiveStreamNotification(raw);
    });
    
    // Host properly ends live stream
    socket?.on("host_live_ended", (raw) async {
      debugPrint("⚫ Host live stream ended: $raw");
      _handleLiveStreamEnded(raw, reason: 'Host ended the live stream');
    });
    
    // Host app closed/crashed/killed (unexpected disconnect)
    socket?.on("host_disconnected", (raw) async {
      debugPrint("🔌 Host disconnected unexpectedly: $raw");
      _handleLiveStreamEnded(raw, reason: 'Host connection lost');
    });
    
    // Host went offline (app in background too long or killed)
    socket?.on("host_went_offline", (raw) async {
      debugPrint("📱 Host went offline: $raw");
      _handleLiveStreamEnded(raw, reason: 'Host went offline');
    });
    
    // Generic live stream status updates
    socket?.on("live_stream_status", (raw) async {
      debugPrint("📡 Live stream status update: $raw");
      _handleLiveStreamStatusUpdate(raw);
    });
    
    // ✅ Host properly calls go-offline API (using app_url.offLiveLiveCall)
    socket?.on("host_goes_offline", (raw) async {
      debugPrint("🔴 Host properly went offline via API: $raw");
      _handleLiveStreamEnded(raw, reason: 'Host properly ended live streaming');
    });
    
    // Alternative event names that backend might send
    socket?.on("host_offline_api_called", (raw) async {
      debugPrint("🔴 Host called go-offline API: $raw");
      _handleLiveStreamEnded(raw, reason: 'Host ended live session');
    });
    
    socket?.on("live_stream_stopped", (raw) async {
      debugPrint("🛑 Live stream stopped: $raw");
      _handleLiveStreamEnded(raw, reason: 'Live stream stopped');
    });
    
    // ✅ Handle host_status updates to catch when host goes offline
    socket?.on("host_status", (raw) async {
      debugPrint("👤 Host status event received: $raw");
      
      try {
        final Map<String, dynamic> data = raw is Map ? Map<String, dynamic>.from(raw) : {};
        final hostId = data['hostId']?.toString() ?? '';
        final status = data['status']?.toString() ?? '';
        final hostName = data['hostName']?.toString() ?? 'Host';
        final roomId = data['roomId']?.toString() ?? '';
        
        debugPrint("👤 Host Status Details: hostId=$hostId, status=$status, hostName=$hostName, roomId=$roomId");
        
        // Check if host went offline
        if (status.toLowerCase() == 'offline') {
          debugPrint("👤 ⚫ HOST WENT OFFLINE DETECTED!");
          debugPrint("👤 Host: $hostName (ID: $hostId)");
          debugPrint("👤 Room: $roomId");
          debugPrint("👤 Triggering live stream ended for viewers...");
          
          _handleLiveStreamEnded(raw, reason: '$hostName ended the live stream');
        }
        
      } catch (e) {
        debugPrint("❌ Error processing host_status event: $e");
      }
    });

    // ✅ Note: call_accepted, call_rejected, call_ended events are already handled above
    // Removing duplicate listeners to prevent confusion
    
    // Additional call status handling
    socket?.on("call_status", (data) {
      debugPrint("📞 Call status update: $data");
      _handleCallStatusUpdate(data);
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
        debugPrint("⚠ incoming_call without callId");
        return;
      }

      if (callerId == AppUrl.riolive_id.toString()) {
        debugPrint("🚫 Ignoring self call");
        return;
      }

      if (_pendingCallDialogs.contains(callId)) return;
      _pendingCallDialogs.add(callId);
      
      // ✅ Track current incoming call for multiple host management
      currentIncomingCallId.value = callId;
      isShowingCallDialog.value = true;

      if (Get.isDialogOpen == true) Get.back();

      // ✅ Toast notification
      Get.snackbar(
        "Incoming Call",
        "$callerName is calling...",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
      );

      // ✅ Simple popup (global fallback)
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

  void _rejectCall(String callId) async {
    try {
      // Call backend reject API
      final c = Get.find<CallController>();
      final success = await c.rejectCall(AppUrl.token, callId);
      
      if (success) {
      socket?.emit("call_rejected", {
        "callId": callId,
        "userId": AppUrl.riolive_id,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
        Get.snackbar("Call Rejected", "Call rejected successfully");
      }
    } catch (e) {
      debugPrint("❌ Error rejecting call: $e");
      Get.snackbar("Error", "Failed to reject call");
    } finally {
      // Clean up call tracking
      _pendingCallDialogs.remove(callId);
      if (callId == currentIncomingCallId.value) {
        currentIncomingCallId.value = null;
        isShowingCallDialog.value = false;
      }
    }
  }

  void _acceptCall(String callId, Map<String, dynamic> data) async {
    try {
      final c = Get.find<CallController>();
      final joinResp = await c.joinCall(AppUrl.token, callId);

      if (joinResp == null) {
        Get.snackbar("Error", "Failed to join call");
        return;
      }

      final channelName = _extractChannelName(joinResp, data);
      final token = _extractToken(joinResp, data);

      if (channelName.isEmpty || token.isEmpty) {
        Get.snackbar("Error", "Invalid call data received");
        return;
      }

      socket?.emit("call_accepted", {
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
          isHost: false, // ✅ accept pe audience/user
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

  void _handleCallStatusUpdate(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final callId = (data['callId'] ?? '').toString();
      final status = (data['status'] ?? '').toString();
      
      debugPrint("📞 Call $callId status: $status");
      
      // Clean up dialog if call ended/rejected
      if (status == 'ended' || status == 'rejected') {
        _pendingCallDialogs.remove(callId);
        currentIncomingCallId.value = null;
        isShowingCallDialog.value = false;
        
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      }
    } catch (e) {
      debugPrint("❌ Error handling call status update: $e");
    }
  }
  
  /// Handle when another host accepts the call
  void _handleCallAcceptedByOther(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final callId = (data['callId'] ?? '').toString();
      final hostName = (data['hostName'] ?? data['userName'] ?? 'Another host').toString();
      final hostId = (data['hostId'] ?? data['userId'] ?? '').toString();
      
      debugPrint("🏆 Call $callId accepted by $hostName (ID: $hostId)");
      
      // If this is the current incoming call and I'm not the one who accepted
      if (callId == currentIncomingCallId.value && hostId != AppUrl.riolive_id.toString()) {
        
        // Close any open dialog
        if (Get.isDialogOpen == true && isShowingCallDialog.value) {
          Get.back();
        }
        
        // Show toast notification
        Get.snackbar(
          "Call Taken",
          "$hostName joined the call",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
        
        // Clean up
        _pendingCallDialogs.remove(callId);
        currentIncomingCallId.value = null;
        isShowingCallDialog.value = false;
        
        debugPrint("✅ Popup closed and toast shown for call taken by another host");
      }
    } catch (e) {
      debugPrint("❌ Error handling call accepted by other: $e");
    }
  }
  
  /// Handle when call is rejected
  void _handleCallRejected(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final callId = (data['callId'] ?? '').toString();
      final hostName = (data['hostName'] ?? data['userName'] ?? 'Host').toString();
      
      debugPrint("❌ Call $callId rejected by $hostName");
      
      // Clean up if this was the current incoming call
      if (callId == currentIncomingCallId.value) {
        _pendingCallDialogs.remove(callId);
        currentIncomingCallId.value = null;
        isShowingCallDialog.value = false;
        
        if (Get.isDialogOpen == true && isShowingCallDialog.value) {
          Get.back();
        }
      }
    } catch (e) {
      debugPrint("❌ Error handling call rejected: $e");
    }
  }
  
  /// Handle when call is ended by either party (Enhanced coordination)
  void _handleCallEnded(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final callId = (data['callId'] ?? '').toString();
      final endedBy = (data['endedBy'] ?? data['userRole'] ?? 'Unknown').toString();
      final userName = (data['userName'] ?? 'User').toString();
      final reason = (data['reason'] ?? 'call_ended').toString();
      final enderId = (data['userId'] ?? '').toString();
      
      debugPrint("🔚 Call $callId ended by $endedBy ($userName) - Reason: $reason");
      
      // Don't handle if I'm the one who ended the call
      if (enderId == AppUrl.riolive_id.toString()) {
        debugPrint("🔚 Ignoring self call end event");
        return;
      }
      
      // ✅ Check if current user is host and was live streaming
      final isHostWasLive = AppUrl.user_role == "host" && currentHostRoom != null;
      
      // ✅ Force close any ongoing call UI with proper navigation
      try {
        // If in video call screen, navigate appropriately
        if (Get.currentRoute.contains('VideoCall')) {
          debugPrint("🔚 Forcing video call screen to close");
          
          if (isHostWasLive) {
            // ✅ Host was live streaming - return to live streaming screen
            debugPrint("🔴 Host was live streaming - navigating back to live screen");
            Get.back(); // Exit video call
            
            // Small delay then reinitialize live streaming
            Future.delayed(const Duration(milliseconds: 500), () {
              reinitializeHostLiveStreaming();
            });
          } else {
            // Regular user or host not live streaming - just go back
            Get.back();
          }
        }
        
        // Close any dialogs
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        
        // Clean up call tracking
        _pendingCallDialogs.remove(callId);
        if (callId == currentIncomingCallId.value) {
          currentIncomingCallId.value = null;
          isShowingCallDialog.value = false;
        }
        
        // Show notification with host-specific message
        final message = isHostWasLive 
            ? "$userName ended the call. Returning to live streaming..."
            : "$userName ended the call";
            
        Get.snackbar(
          "Call Ended",
          message,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.grey[800],
          colorText: Colors.white,
          icon: const Icon(Icons.call_end, color: Colors.red),
        );
        
        // ✅ Force Agora cleanup
        try {
          final callController = Get.find<CallController>();
          callController.leaveChannel();
          debugPrint("🔚 Forced Agora cleanup completed");
        } catch (e) {
          debugPrint("⚠ Agora cleanup error: $e");
        }
        
        debugPrint("✅ Call end coordination completed - Both sides should be synchronized");
        
      } catch (e) {
        debugPrint("❌ Error during call end coordination: $e");
      }
      
    } catch (e) {
      debugPrint("❌ Error handling call ended: $e");
    }
  }
  
  /// Reinitialize host live streaming after call ends
  Future<void> reinitializeHostLiveStreaming() async {
    try {
      if (AppUrl.user_role != "host" || currentHostRoom == null) {
        debugPrint("❌ Cannot reinitialize - not a host or no room");
        return;
      }
      
      debugPrint("🔄 Reinitializing host live streaming...");
      
      // Ensure host is still marked as live and available for calls
      await _setHostLiveStatus(true, currentHostRoom!);
      
      // Rejoin host room for future calls
      joinHostRoom(currentHostRoom!);
      
      // ✅ Check if host should return to live streaming screen
      await _ensureHostReturnToLiveScreen();
      
      debugPrint("✅ Host live streaming reinitialized successfully");
      
      Get.snackbar(
        "Live Streaming Restored",
        "You're back live and ready for calls!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.live_tv, color: Colors.white),
      );
      
    } catch (e) {
      debugPrint("❌ Error reinitializing host live streaming: $e");
      Get.snackbar(
        "Error", 
        "Failed to restore live streaming. Please restart manually.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  /// Ensure host returns to live streaming screen if not already there
  Future<void> _ensureHostReturnToLiveScreen() async {
    try {
      final currentRoute = Get.currentRoute;
      debugPrint("🔍 Current route: $currentRoute");
      
      // Check if host is not on live streaming screen
      if (!currentRoute.contains('HostStartLiveStreamingScreen')) {
        debugPrint("🔄 Host not on live streaming screen - checking navigation options");
        
        // Try to navigate back to live streaming screen
        // This depends on your app's navigation structure
        
        // Option 1: If there's a specific way to get back to live streaming
        // Get.offAll(() => HostStartLiveStreamingScreen());
        
        // Option 2: Show a dialog to let host know they can continue streaming
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "Continue Live Streaming?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: const Text(
              "Your call has ended. Would you like to continue live streaming to receive more calls?",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  debugPrint("🔴 Host chose to stop live streaming");
                  removeHostFromCalls(); // Stop being available for calls
                },
                child: const Text(
                  "Stop Streaming",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back(); // Close dialog
                  debugPrint("🔴 Host chose to continue live streaming");
                  
                  // ✅ Restart camera and live streaming
                  await _restartHostLiveStreaming();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Continue Streaming",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        debugPrint("✅ Host is already on live streaming screen");
        
        // ✅ Even if on live screen, offer to restart camera to fix any hanging issues
        final bool? shouldRestart = await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.95),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Restart Camera?",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: const Text(
              "Your call has ended. Would you like to restart your camera to ensure smooth streaming?",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Continue As Is', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('🔄 Restart Camera', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (shouldRestart == true) {
          await _restartHostLiveStreaming();
        } else {
          Get.snackbar(
            "Ready for Calls",
            "Live streaming continues - ready for new calls!",
            backgroundColor: Colors.blue.withOpacity(0.8),
            colorText: Colors.white,
            icon: const Icon(Icons.phone_in_talk, color: Colors.white),
            duration: const Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error ensuring host return to live screen: $e");
    }
  }

  /// Restart host live streaming with fresh camera
  Future<void> _restartHostLiveStreaming() async {
    try {
      debugPrint("🔄 Restarting host live streaming with fresh camera...");
      
      // Show loading
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.black87,
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(width: 16),
              Text('🔄 Restarting camera...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // ✅ Force camera restart by triggering CallController reinit
      try {
        final callController = Get.find<CallController>();
        
        // First completely leave current channel
        await callController.leaveChannel();
        debugPrint("📱 Left previous channel");
        
        // Wait a moment for cleanup
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Get current arguments from live streaming screen
        final args = Get.arguments as Map<String, dynamic>?;
        if (args != null) {
          debugPrint("🔄 Reinitializing with args: $args");
          
          // Reinitialize Agora with fresh settings
          await callController.initAgora(
            channelName: args["channelName"],
            agoraToken: args["token"],
            appId: args["appId"],
            isHost: args["isHost"] ?? true,
            isAudience: false,
            callId: args["channelName"],
          );
          
          debugPrint("✅ Camera successfully reinitialized");
        } else {
          debugPrint("⚠️ No arguments available for reinitialization");
          throw Exception("No streaming arguments available");
        }
        
      } catch (e) {
        debugPrint("❌ Error during camera restart: $e");
        throw e;
      }

      // Small delay then close loading
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (Get.isDialogOpen == true) {
        Get.back(); // Close loading dialog
      }

      Get.snackbar(
        "🔄 Camera Restarted",
        "Live streaming resumed with fresh camera!",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.videocam, color: Colors.white),
      );
      
    } catch (e) {
      debugPrint("❌ Error restarting live streaming: $e");
      
      if (Get.isDialogOpen == true) {
        Get.back(); // Close loading dialog
      }
      
      Get.snackbar(
        "❌ Restart Failed", 
        "Could not restart camera. Please restart manually.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void _handleLiveStreamNotification(dynamic raw) {
    // extend kar sakte ho agar lives ke liye toast/popup dikhani ho
  }
  
  /// Handle when live stream ends (for viewers)
  void _handleLiveStreamEnded(dynamic raw, {required String reason}) {
    try {
      debugPrint("⚫ ===========================================");
      debugPrint("⚫ LIVE STREAM ENDED EVENT");
      debugPrint("⚫ Raw data: $raw");
      debugPrint("⚫ Reason: $reason");
      debugPrint("⚫ Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("⚫ Current user role: ${AppUrl.user_role}");
      debugPrint("⚫ Current route: ${Get.currentRoute}");
      debugPrint("⚫ ===========================================");
      
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final hostId = data['hostId']?.toString() ?? '';
      final hostName = data['hostName']?.toString() ?? 'Host';
      final streamId = data['streamId']?.toString() ?? '';
      
      debugPrint("⚫ Host ID: $hostId");
      debugPrint("⚫ Host Name: $hostName");
      debugPrint("⚫ Stream ID: $streamId");
      
      // Only show to viewers (users who are not hosts)
      if (AppUrl.user_role == 'host') {
        debugPrint("⚫ Current user is host - not showing live ended message");
        return;
      }
      
      // Check if user is currently watching live stream
      final currentRoute = Get.currentRoute;
      final isWatchingLive = currentRoute.contains('Live') || 
                            currentRoute.contains('Stream') || 
                            currentRoute.contains('Host');
      
      debugPrint("⚫ Is watching live stream: $isWatchingLive");
      debugPrint("⚫ Current route: $currentRoute");
      
      if (isWatchingLive) {
        // Show live ended dialog and navigate back
        _showLiveStreamEndedDialog(hostName, reason);
      } else {
        // Just show a toast notification
        Get.snackbar(
          '⚫ Live Stream Ended',
          '$hostName\'s live stream has ended',
          backgroundColor: Colors.grey[800],
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.tv_off, color: Colors.white),
          snackPosition: SnackPosition.TOP,
        );
      }
      
    } catch (e) {
      debugPrint("💥 Error handling live stream ended: $e");
    }
  }
  
  /// Handle live stream status updates
  void _handleLiveStreamStatusUpdate(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};
      
      final status = data['status']?.toString() ?? '';
      final hostId = data['hostId']?.toString() ?? '';
      final hostName = data['hostName']?.toString() ?? 'Host';
      
      debugPrint("📡 Live stream status: $status for $hostName (ID: $hostId)");
      
      if (status == 'ended' || status == 'offline' || status == 'disconnected') {
        _handleLiveStreamEnded(data, reason: 'Live stream $status');
      }
      
    } catch (e) {
      debugPrint("💥 Error handling live stream status update: $e");
    }
  }
  
  /// Show dialog when live stream ends while user is watching
  void _showLiveStreamEndedDialog(String hostName, String reason) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tv_off, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Live Stream Ended',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$hostName\'s live stream has ended.',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              reason,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'You will be redirected back.',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              _navigateBackFromLiveStream();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
  
  /// Navigate back when live stream ends
  void _navigateBackFromLiveStream() {
    try {
      debugPrint("🔙 Navigating back from ended live stream");
      debugPrint("🔙 Current route: ${Get.currentRoute}");
      
      // Force close any video/live streaming related screens
      final currentRoute = Get.currentRoute;
      
      if (currentRoute.contains('Live') || 
          currentRoute.contains('Stream') || 
          currentRoute.contains('Host') ||
          currentRoute.contains('Video')) {
        
        Get.back();
        
        // Small delay then show confirmation
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar(
            '⚫ Stream Ended',
            'Live stream has ended. You have been redirected back.',
            backgroundColor: Colors.grey[800],
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
      
    } catch (e) {
      debugPrint("❌ Error navigating back from live stream: $e");
    }
  }

  // ================= HOST ROOM METHODS =================
  
  /// Test if host is properly set up to receive calls
  void testHostSetup() {
    if (AppUrl.user_role != "host") {
      debugPrint("❌ User is not a host - cannot test host setup");
      return;
    }
    
    debugPrint("🧪 Testing host setup...");
    debugPrint("🧪 Socket connected: ${isConnected.value}");
    debugPrint("🧪 Current host room: $currentHostRoom");
    debugPrint("🧪 User role: ${AppUrl.user_role}");
    debugPrint("🧪 User ID: ${AppUrl.riolive_id}");
    debugPrint("🧪 Socket ID: ${socket?.id}");
    
    // Check host database status
    _checkHostDatabaseStatus();
    
    // Send test message to verify room membership
    if (currentHostRoom != null) {
      socket?.emit("test_host_presence", {
        "roomId": currentHostRoom,
        "userId": AppUrl.riolive_id,
        "message": "Host testing presence in room"
      });
      debugPrint("🧪 Sent test presence message to room: $currentHostRoom");
    }
    
    // Simulate an incoming call for testing (DISABLED)
    // _testIncomingCallListener(); // ❌ Removed - causing fake popups
  }
  
  /// Check host status in database
  Future<void> _checkHostDatabaseStatus() async {
    try {
      debugPrint("🔍 Checking host database status...");
      
      // Use existing endpoint or create a simple profile check
      final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/users/me"),
        headers: {"Authorization": "Bearer ${AppUrl.token}"},
      ).timeout(Duration(seconds: 10));
      
      debugPrint("🔍 Host DB status response: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("🔍 Host DB data: $data");
        
        final user = data['user'] ?? data;
        debugPrint("🔍 Host role in DB: ${user['role']}");  
        debugPrint("🔍 Host is_live in DB: ${user['is_live']}");
        debugPrint("🔍 Host room_id in DB: ${user['room_id']}");
        debugPrint("🔍 Host username in DB: ${user['username']}");
      }
      
    } catch (e) {
      debugPrint("❌ Host database check failed: $e");
    }
  }
  
  
  /// Verify if host appears in live list
  Future<void> _verifyHostInLiveList() async {
    try {
      debugPrint("🔍 Verifying if host appears in live list...");
      
      final endpoints = [
        "${AppUrl.baseUrl}/api/hosts/live-list",
        "${AppUrl.baseUrl}/api/hosts/available",
        "${AppUrl.baseUrl}/api/random/calls/hosts",
      ];
      
      for (String endpoint in endpoints) {
        try {
          debugPrint("🔍 Checking endpoint: $endpoint");
          
          final response = await http.get(
            Uri.parse(endpoint),
            headers: {"Authorization": "Bearer ${AppUrl.token}"},
          ).timeout(Duration(seconds: 10));
          
          debugPrint("🔍 Live list response - Status: ${response.statusCode}");
          
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            debugPrint("🔍 Live list data: $data");
            
            // Check if current host is in the list
            final currentHostId = AppUrl.riolive_id.toString();
            bool foundHost = _checkHostInResponseData(data, currentHostId);
            
            if (foundHost) {
              debugPrint("✅ Host found in live list! Host is properly registered as live.");
              return;
            } else {
              debugPrint("❌ Host NOT found in live list from $endpoint");
            }
          }
          
        } catch (e) {
          debugPrint("❌ Error checking endpoint $endpoint: $e");
        }
      }
      
      debugPrint("❌ Host not found in any live list endpoint - this might be why calls aren't coming!");
      
    } catch (e) {
      debugPrint("❌ Error verifying host in live list: $e");
    }
  }
  
  /// Check if host exists in response data
  bool _checkHostInResponseData(dynamic data, String hostId) {
    try {
      List<dynamic> hosts = [];
      
      if (data is Map<String, dynamic>) {
        if (data['hosts'] is List) {
          hosts = data['hosts'];
        } else if (data['data'] is List) {
          hosts = data['data'];
        } else if (data['liveHosts'] is List) {
          hosts = data['liveHosts'];
        } else if (data['users'] is List) {
          hosts = data['users'];
        } else if (data['livestreams'] is List) {
          hosts = data['livestreams'];
        }
      } else if (data is List) {
        hosts = data;
      }
      
      for (var host in hosts) {
        if (host is Map<String, dynamic>) {
          final id = host['id']?.toString() ?? host['hostId']?.toString() ?? '';
          if (id == hostId) {
            debugPrint("✅ Found host in list: $host");
            return true;
          }
        }
      }
      
      return false;
    } catch (e) {
      debugPrint("❌ Error checking host in response data: $e");
      return false;
    }
  }
  
  /// Setup host room - create room and mark as live
  Future<void> _setupHostRoom(String userId) async {
    try {
      debugPrint("👑 Setting up host room for userId: $userId");
      
      // Create unique room for host
      final hostRoomId = "host_room_${userId}_${DateTime.now().millisecondsSinceEpoch}";
      debugPrint("🏠 Created host room: $hostRoomId");
      
      // Mark host as live (simplified approach)
      await _setHostLiveStatus(true, hostRoomId);
      
      // Join the room for incoming calls
      joinHostRoom(hostRoomId);
      
      debugPrint("✅ Host setup completed successfully!");
      
      // Wait a moment then test the setup
      Future.delayed(Duration(seconds: 3), () {
        testHostSetup();
      });
      
      // Also check if host shows up in live list
      Future.delayed(Duration(seconds: 5), () {
        _verifyHostInLiveList();
      });
      
    } catch (e) {
      debugPrint("❌ Error setting up host room: $e");
      // Simple fallback - just join a room
      final fallbackRoomId = "host_room_${userId}_${DateTime.now().millisecondsSinceEpoch}";
      joinHostRoom(fallbackRoomId);
    }
  }
  
  
  /// Set host live status and room_id - try different endpoints
  Future<void> _setHostLiveStatus(bool isLive, String roomId) async {
    try {
      debugPrint("🔴 Attempting to set host live status: $isLive, RoomId: $roomId");
      
      // Method 1: Use live streaming endpoint (this should update live-list)
      try {
        final endpoint = isLive ? AppUrl.goLiveCall : AppUrl.offLiveLiveCall;
        debugPrint("🔴 Using endpoint: $endpoint");
        
        final body = isLive ? {
          "room_id": roomId,
          "title": "Available for calls",
          "description": "Host available for random calls"
        } : {};
        
        final response = await http.post(
          Uri.parse(endpoint),
          headers: {
            "Authorization": "Bearer ${AppUrl.token}",
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        );
        
        debugPrint("🔴 Live streaming endpoint response: ${response.statusCode}");
        debugPrint("🔴 Live streaming response body: ${response.body}");
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("✅ Host live status successfully set via streaming endpoint");
          return;
        }
      } catch (e) {
        debugPrint("❌ Live streaming endpoint failed: $e");
      }
      
      // Method 2: Direct database update (fallback)
      try {
        final response = await http.put(
          Uri.parse("${AppUrl.baseUrl}/api/users/profile"),
          headers: {
            "Authorization": "Bearer ${AppUrl.token}",
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "is_live": isLive,
            "room_id": roomId,
          }),
        );
        debugPrint("🔴 Profile update response: ${response.statusCode}");
        if (response.statusCode == 200 || response.statusCode == 201) return;
      } catch (e) {
        debugPrint("❌ Profile update failed: $e");
      }
      
      // If all methods fail, continue with socket-only approach
      debugPrint("⚠ Backend API not available - using socket-only approach");
      
    } catch (e) {
      debugPrint("❌ Error setting live status: $e");
    }
  }
  
  /// Join host to their room for incoming call notifications
  void joinHostRoom(String roomId) {
    if (!isConnected.value) {
      debugPrint("❌ Socket not connected - cannot join host room");
      return;
    }
    
    try {
      currentHostRoom = roomId;
      
      // Multiple room join methods to ensure compatibility
      debugPrint("🏠 Joining room with multiple methods: $roomId");
      
      // Method 1: Direct socket join
      socket?.emit("join_room", {"roomId": roomId});
      
      // Method 2: Alternative format
      socket?.emit("join", {"room": roomId});
      
      // Method 3: Host specific join
      socket?.emit("host_join", {
        "roomId": roomId, 
        "userId": AppUrl.riolive_id,
        "role": "host"
      });
      
      // Method 4: Use socket.io built-in join
      socket?.emit("join_room", roomId);
      
      debugPrint("✅ Host joined room with all methods: $roomId");
      
    } catch (e) {
      debugPrint("❌ Error joining host room: $e");
    }
  }
  
  /// Leave current host room
  void leaveHostRoom() {
    if (currentHostRoom != null && isConnected.value) {
      try {
        socket?.emit("leave_room", {"roomId": currentHostRoom});
        debugPrint("🚪 Host left room: $currentHostRoom");
        currentHostRoom = null;
      } catch (e) {
        debugPrint("❌ Error leaving host room: $e");
      }
    }
  }

  // ================= EMIT METHODS =================

  // ⚠ NOTE: aapki requirement ke mutabiq, "start call" pe koi emit NHI karna.
  // Ye helper rehne diya hai lekin use na karein.
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
      debugPrint("📤 (DISCOURAGED) Emitting call_started: $enrichedPayload");
      // socket?.emit("call_started", enrichedPayload); // ← INTENTIONALLY DISABLED
    } catch (e) {
      debugPrint("❌ Error emitting call_started: $e");
    }
  }

  void _attemptReconnectionThenEmit(String event, dynamic data) {
    debugPrint("🔄 Attempting reconnection before emitting $event");

    if (!_isConnecting) {
      initSocket(AppUrl.token, AppUrl.riolive_id.toString());
    }

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

    // Set host offline before disconnecting
    if (AppUrl.user_role == "host" && currentHostRoom != null) {
      _setHostLiveStatus(false, currentHostRoom!);
    }

    // Leave host room before disconnecting
    leaveHostRoom();

    if (socket != null) {
      // important: saare listeners band karo
      socket?.off("incoming_call");
      socket?.off("call_started");
      socket?.off("call_status");
      socket?.off("host_status");
      socket?.off("call_accepted");
      socket?.off("call_rejected");
      socket?.off("call_ended");
      socket?.off("host_joined_live");
      
      // ✅ Clean up live stream listeners
      socket?.off("host_live_ended");
      socket?.off("host_disconnected");
      socket?.off("host_went_offline");
      socket?.off("live_stream_status");
      socket?.off("host_goes_offline");
      socket?.off("host_offline_api_called");
      socket?.off("live_stream_stopped");
      socket?.off("host_status");
      
      // ✅ Clean up private call listeners
      socket?.off("private_call_request");
      socket?.off("private_call_accepted");
      socket?.off("private_call_rejected");
      socket?.off("private_call_ended");
      socket?.off("private_call_status");

      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }

    isConnected.value = false;
    connectionStatus.value = 'disconnected';
  }

  void debugSocketStatus() {
    debugPrint("🔍 === SOCKET STATUS ===");
    debugPrint("🔍 Connected: ${isConnected.value}");
    debugPrint("🔍 Status: ${connectionStatus.value}");
    debugPrint("🔍 Socket instance: ${socket != null ? "Exists" : "Null"}");
    debugPrint("🔍 Socket ID: ${socket?.id}");
    debugPrint("🔍 Reconnect attempts: $_reconnectAttempts");
    debugPrint("🔍 =====================");
  }


  bool get isSocketReady => isConnected.value && socket != null;

  /// Workaround for missing tokens - try to fetch and join call
  void _handleMissingTokensWorkaround(String callId, String roomId, String requesterId) async {
    try {
      debugPrint("🔧 ==========================================");
      debugPrint("🔧 MISSING TOKENS WORKAROUND");
      debugPrint("🔧 Call ID: $callId");
      debugPrint("🔧 Room ID: $roomId");
      debugPrint("🔧 Requester ID: $requesterId");
      debugPrint("🔧 Attempting to fetch Agora token...");
      debugPrint("🔧 ==========================================");

      // Try to fetch Agora token for this room
      final controller = Get.find<CallController>();
      
      // Convert requester ID to int for Agora (this should match backend token generation)
      int userUid;
      try {
        if (requesterId.isNotEmpty) {
          userUid = int.parse(requesterId);
          debugPrint("🔧 Using backend requester ID as UID: $userUid");
        } else {
          userUid = int.parse(AppUrl.riolive_id.toString());
          debugPrint("🔧 Fallback: Using AppUrl.riolive_id as UID: $userUid");
        }
      } catch (e) {
        debugPrint("🔧 ❌ Failed to parse requester ID as int: $requesterId");
        debugPrint("🔧 Using fallback UID: 3"); // Common backend user ID
        userUid = 3; // Backend seems to use 3 as requester ID
      }
      
      final agoraToken = await controller.fetchAgoraToken(
        token: AppUrl.token,
        channelName: roomId,
        uid: userUid,
        role: 'user',
      );

      if (agoraToken != null && agoraToken.isNotEmpty) {
          debugPrint("🔧 ✅ Successfully fetched Agora token");
        debugPrint("🔧 Token: ${agoraToken.substring(0, 20)}...");
        debugPrint("🔧 ==========================================");
        debugPrint("🔧 NAVIGATING TO VIDEO CALL SCREEN");
        debugPrint("🔧 Call ID: $callId");
        debugPrint("🔧 Channel Name: $roomId");
        debugPrint("🔧 User Token: ${AppUrl.token?.substring(0, 20) ?? 'null'}...");
        debugPrint("🔧 Agora Token: ${agoraToken.substring(0, 20)}...");
        debugPrint("🔧 Is Host: false");
        debugPrint("🔧 User UID: $userUid (MATCHES BACKEND TOKEN)");
        debugPrint("🔧 Event Requester ID: $requesterId");
        debugPrint("🔧 AppUrl.riolive_id: ${AppUrl.riolive_id}");
        debugPrint("🔧 ==========================================");
        
        try {
          // Navigate to video call screen with CORRECT UID
          // CRITICAL: Use same UID that backend token was generated for
          final result = Get.to(
            () => VideoCallScreen(
              token: AppUrl.token,
              callId: callId,
              channelName: roomId,
              agoraToken: agoraToken,
              isHost: false,
              providedUid: userUid, // ✅ Use backend requester ID as UID that matches token
            ),
          );
          
          debugPrint("🔧 ✅ Navigation initiated successfully");
          debugPrint("🔧 Navigation result: $result");
          
        } catch (navError) {
          debugPrint("🔧 ❌ Navigation error: $navError");
          debugPrint("🔧 Navigation error type: ${navError.runtimeType}");
          debugPrint("🔧 Stack trace: ${StackTrace.current}");
          
          Get.snackbar(
            '❌ Navigation Error',
            'Failed to open video call: $navError',
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
        
      } else {
        debugPrint("🔧 ❌ Failed to fetch Agora token");
        debugPrint("🔧 Token response: $agoraToken");
        
        Get.snackbar(
          '❌ Connection Error',
          'Unable to connect to private call. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }

    } catch (e) {
      debugPrint("🔧 ❌ Error in missing tokens workaround: $e");
      
      Get.snackbar(
        '❌ Connection Error',
        'Failed to setup private call connection: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // ================== PRIVATE CALL HANDLERS ==================
  
  /// Handle private call request (for hosts)
  void _handlePrivateCallRequest(dynamic raw) {
    try {
      debugPrint("📞 ===========================================");
      debugPrint("📞 PRIVATE CALL REQUEST RECEIVED!");
      debugPrint("📞 Raw Data: $raw");
      debugPrint("📞 Data Type: ${raw.runtimeType}");
      debugPrint("📞 ===========================================");
      
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      // ✅ Extract all possible field names
      final callId = (data['privateCallId'] ?? data['callId'] ?? data['id'] ?? '').toString();
      final callerId = (data['requesterId'] ?? data['callerId'] ?? data['userId'] ?? '').toString();
      final callerName = (data['requesterName'] ?? data['callerName'] ?? data['userName'] ?? 'Unknown User').toString();
      final userProfilePic = data['userProfilePic']?.toString();
      final randomCallId = (data['randomCallId'] ?? '').toString();

      debugPrint("📞 ===========================================");
      debugPrint("📞 EXTRACTED DATA:");
      debugPrint("📞 Private Call ID: $callId");
      debugPrint("📞 Caller ID: $callerId");
      debugPrint("📞 Caller Name: $callerName");
      debugPrint("📞 Random Call ID: $randomCallId");
      debugPrint("📞 User Profile Pic: $userProfilePic");
      debugPrint("📞 Current User Role: ${AppUrl.user_role}");
      debugPrint("📞 Current User ID: ${AppUrl.riolive_id}");
      debugPrint("📞 Socket ID: ${socket?.id}");
      debugPrint("📞 ===========================================");

      // ✅ Validation
      if (callId.isEmpty) {
        debugPrint("❌ Invalid private call request: missing privateCallId/callId");
        return;
      }

      if (callerId.isEmpty) {
        debugPrint("❌ Invalid private call request: missing requesterId/callerId");
        return;
      }

      // Only show popup if user is a host
      if (AppUrl.user_role != 'host') {
        debugPrint("⚠️ Ignoring private call request - Current user is not a host (Role: ${AppUrl.user_role})");
        return;
      }

      // Don't show if caller is self
      if (callerId == AppUrl.riolive_id.toString()) {
        debugPrint("🚫 Ignoring self private call request");
        return;
      }

      // Check if host is currently live streaming - if so, let live streaming screen handle it
      final currentRoute = Get.currentRoute;
      if (currentRoute.contains('HostStartLiveStreamingScreen')) {
        debugPrint("🎙️ Host is live streaming - letting live streaming screen handle private call");
        debugPrint("🎙️ Current route: $currentRoute");
        return; // Let host_start_live_streaming_screen.dart handle it
      }

      debugPrint("✅ ===========================================");
      debugPrint("✅ SHOWING PRIVATE CALL REQUEST POPUP (Socket Service)");
      debugPrint("✅ From: $callerName (ID: $callerId)");
      debugPrint("✅ To: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("✅ Private Call ID: $callId");
      debugPrint("✅ Current Route: $currentRoute");
      debugPrint("✅ ===========================================");

      // Show private call request popup to host
      _showPrivateCallRequestPopup(
        callId: callId,
        callerId: callerId,
        callerName: callerName,
        userProfilePic: userProfilePic,
      );

    } catch (e) {
      debugPrint("💥 ===========================================");
      debugPrint("💥 ERROR HANDLING PRIVATE CALL REQUEST!");
      debugPrint("💥 Error: $e");
      debugPrint("💥 Error Type: ${e.runtimeType}");
      debugPrint("💥 Raw Data: $raw");
      debugPrint("💥 Stack Trace: ${StackTrace.current}");
      debugPrint("💥 ===========================================");
    }
  }

  /// Handle private call accepted (for users)
  void _handlePrivateCallAccepted(dynamic raw) {
    try {
      debugPrint("✅ ==========================================");
      debugPrint("✅ PRIVATE CALL ACCEPTED EVENT RECEIVED");
      debugPrint("✅ Raw data: $raw");
      debugPrint("✅ ==========================================");
      
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final callId = (data['privateCallId'] ?? data['callId'] ?? data['id'] ?? '').toString();
      final hostName = (data['hostName'] ?? 'Host').toString();
      final agoraData = data['agora'];
      
      // Handle both private_call_accepted and private_call_status event structures
      final roomId = agoraData?['roomId']?.toString() ?? data['roomId']?.toString();
      final appId = agoraData?['appId']?.toString();
      final requesterToken = agoraData?['requester']?['token']?.toString();
      final requesterUid = agoraData?['requester']?['uid'];
      
      debugPrint("🔍 Extracted Navigation Data:");
      debugPrint("🔍 - Room ID: $roomId");
      debugPrint("🔍 - App ID: $appId");
      debugPrint("🔍 - Requester Token Available: ${requesterToken != null}");
      debugPrint("🔍 - Requester UID: $requesterUid");
      debugPrint("🔍 - Has Agora Data: ${agoraData != null}");
      debugPrint("🔍 - Event Source: ${agoraData != null ? 'private_call_accepted' : 'private_call_status'}");

      debugPrint("✅ Extracted Data:");
      debugPrint("✅ - Call ID: $callId");
      debugPrint("✅ - Host Name: $hostName");
      debugPrint("✅ - Room ID: $roomId");
      debugPrint("✅ - App ID: $appId");
      debugPrint("✅ - Requester UID: $requesterUid");
      debugPrint("✅ - Token Length: ${requesterToken?.length ?? 0}");

      if (callId.isEmpty) {
        debugPrint("❌ Invalid private call accepted data: missing callId");
        return;
      }

      // Close any loading dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show success message
      Get.snackbar(
        '✅ Call Accepted',
        '$hostName accepted your private call request!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.videocam, color: Colors.white),
      );

      // Navigate to private video call if Agora data is available
      if (roomId != null && requesterToken != null && appId != null) {
        debugPrint("📞 ==========================================");
        debugPrint("📞 NAVIGATING TO PRIVATE CALL SCREEN");
        debugPrint("📞 Channel: $roomId");
        debugPrint("📞 Token: ${requesterToken.substring(0, 20)}...");
        debugPrint("📞 UID: $requesterUid");
        debugPrint("📞 ==========================================");
        
        // Navigate to video call screen for private call
        Get.to(
          () => VideoCallScreen(
            token: AppUrl.token,
            callId: callId,
            channelName: roomId,
            agoraToken: requesterToken,
            isHost: false, // User is not host in private call
            providedUid: requesterUid, // ✅ FIX: Use backend-provided UID that matches token
          ),
        );
      } else if (roomId != null) {
        // 🔧 TEMPORARY WORKAROUND: We have roomId but missing tokens
        debugPrint("🔧 ==========================================");
        debugPrint("🔧 PARTIAL DATA RECEIVED - ATTEMPTING WORKAROUND");
        debugPrint("🔧 Room ID: $roomId");
        debugPrint("🔧 Call ID: $callId");
        debugPrint("🔧 Missing: Agora tokens");
        debugPrint("🔧 ==========================================");
        
        Get.snackbar(
          '✅ Call Accepted!',
          'Host accepted your call. Setting up connection...',
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.videocam, color: Colors.white),
        );
        
        // Try to fetch tokens and join the call
        final requesterId = data['requesterId']?.toString() ?? '';
        _handleMissingTokensWorkaround(callId, roomId, requesterId);
        
      } else {
        debugPrint("❌ Missing Agora data for private call navigation");
        debugPrint("❌ Room ID: $roomId, Token: ${requesterToken != null}, App ID: $appId");
        debugPrint("❌ Full event data: $data");
        
        Get.snackbar(
          '⚠️ Call Data Missing',
          'Call was accepted but connection data is incomplete',
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }

    } catch (e) {
      debugPrint("💥 ==========================================");
      debugPrint("💥 ERROR HANDLING PRIVATE CALL ACCEPTED");
      debugPrint("💥 Error: $e");
      debugPrint("💥 Raw data: $raw");
      debugPrint("💥 ==========================================");
    }
  }

  /// Handle private call rejected (for users)
  void _handlePrivateCallRejected(dynamic raw) {
    try {
      debugPrint("❌ ===========================================");
      debugPrint("❌ PRIVATE CALL REJECTED EVENT RECEIVED");
      debugPrint("❌ Raw data: $raw");
      debugPrint("❌ Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("❌ ===========================================");
      
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      // Extract data based on backend response structure
      final callId = (data['privateCallId'] ?? data['callId'] ?? data['id'] ?? '').toString();
      final hostName = data['hostName']?.toString() ?? 'Host';
      final reason = data['reason']?.toString() ?? 'declined';
      final requesterId = data['requesterId']?.toString();

      debugPrint("❌ Extracted Data:");
      debugPrint("❌ - Call ID: $callId");
      debugPrint("❌ - Host Name: $hostName");
      debugPrint("❌ - Reason: $reason");
      debugPrint("❌ - Requester ID: $requesterId");

      // Note: We've already determined this rejection is relevant for current user in the main event handler
      // So we don't need to do strict ID matching here - just show the rejection message
      debugPrint("✅ Private call rejection confirmed for current user (determined by relevance check)");

      // Close any loading dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show simple rejection message to user
      Get.snackbar(
        '❌ Call Declined',
        'The host declined your private call request',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.call_end, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      debugPrint("💥 Error handling private call rejected: $e");
    }
  }

  /// Handle private call ended
  void _handlePrivateCallEnded(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      final callId = (data['callId'] ?? data['id'] ?? '').toString();
      final endedBy = data['endedBy']?.toString() ?? 'Unknown';

      debugPrint("🔚 Private call ended - CallID: $callId, Ended by: $endedBy");

      // Show call ended message
      Get.snackbar(
        '🔚 Call Ended',
        'Private call has been ended',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.call_end, color: Colors.white),
      );

      // TODO: Navigate back from private call screen if currently in one

    } catch (e) {
      debugPrint("❌ Error handling private call ended: $e");
    }
  }

  /// Handle private call ended by other party (enhanced with proper navigation)
  void _handlePrivateCallEndedByOther(dynamic raw) {
    try {
      final Map<String, dynamic> data = raw is Map
          ? Map<String, dynamic>.from(raw)
          : {};

      debugPrint("🔚 ==========================================");
      debugPrint("🔚 PRIVATE CALL ENDED BY OTHER PARTY");
      debugPrint("🔚 Raw event data: $data");
      debugPrint("🔚 Current user: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("🔚 Current user role: ${AppUrl.user_role}");
      debugPrint("🔚 Current route: ${Get.currentRoute}");
      debugPrint("🔚 ==========================================");

      final callId = (data['callId'] ?? data['privateCallId'] ?? data['id'] ?? '').toString();
      final requesterId = data['requesterId']?.toString() ?? '';
      final hostId = data['hostId']?.toString() ?? '';
      final message = data['message']?.toString() ?? 'Private call has ended';

      debugPrint("🔚 Call ID: $callId");
      debugPrint("🔚 Requester ID: $requesterId");
      debugPrint("🔚 Host ID: $hostId");
      debugPrint("🔚 Message: $message");

      // ✅ Determine who the user is in this call
      bool isUserTheRequester = requesterId == AppUrl.riolive_id.toString();
      bool isUserTheHost = hostId == AppUrl.riolive_id.toString();
      
      debugPrint("🔚 Is user the requester: $isUserTheRequester");
      debugPrint("🔚 Is user the host: $isUserTheHost");

      if (!isUserTheRequester && !isUserTheHost) {
        debugPrint("🔚 Call ended event not relevant to current user - ignoring");
        return;
      }

      // ✅ Close any existing dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // ✅ Show call ended notification
      Get.snackbar(
        '🔚 Call Ended',
        isUserTheHost ? 'The user ended the private call' : 'The host ended the private call',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.call_end, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );

      // ✅ Handle navigation based on current screen and user role
      _handleCallEndedNavigation(isUserTheHost: isUserTheHost);

    } catch (e) {
      debugPrint("❌ Error handling private call ended by other: $e");
    }
  }

  /// Handle navigation when call ends based on user role and current screen
  void _handleCallEndedNavigation({required bool isUserTheHost}) {
    try {
      debugPrint("🧭 ==========================================");
      debugPrint("🧭 HANDLING CALL ENDED NAVIGATION");
      debugPrint("🧭 Is user the host: $isUserTheHost");
      debugPrint("🧭 Current route: ${Get.currentRoute}");
      debugPrint("🧭 User role: ${AppUrl.user_role}");
      debugPrint("🧭 ==========================================");

      // ✅ If currently in video call screen, let it handle its own navigation
      if (Get.currentRoute.contains('VideoCallScreen')) {
        debugPrint("🧭 Currently in video call screen - letting it handle navigation");
        // Force end call in video call screen (the screen will handle navigation)
        Get.back(); // This will trigger the proper navigation flow in VideoCallScreen
        return;
      }

      // ✅ Handle different scenarios based on user role and where they are
      if (isUserTheHost && AppUrl.user_role == 'host') {
        debugPrint("🧭 HOST ended call - checking if need to return to live streaming");
        
        // ✅ CRITICAL: Prevent user from accessing live stream
        // Instead of automatically continuing live streaming, navigate back properly
        if (Get.currentRoute.contains('HostStartLiveStreamingScreen')) {
          debugPrint("🧭 Host is on live streaming screen - staying there");
          // Host is already on live streaming screen, show message that call ended
          Get.snackbar(
            '🔚 Private Call Ended',
            'You ended the private call. You are still live for new calls.',
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (!isUserTheHost) {
        debugPrint("🧭 USER call ended - navigating back normally");
        
        // ✅ CRITICAL: User should NEVER go to live stream
        // If user is somehow on live streaming screen or being navigated there, go back
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.currentRoute.contains('HostStartLiveStreamingScreen') || 
              Get.currentRoute.contains('LiveStreamingScreen')) {
            debugPrint("🚨 User incorrectly on live streaming screen - navigating back");
            
            Get.back();
            
            Get.snackbar(
              '⚫ Live Stream Ended',
              'The host is no longer available. Going back...',
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      }

    } catch (e) {
      debugPrint("❌ Error in call ended navigation: $e");
    }
  }

  /// Show private call request popup to host
  void _showPrivateCallRequestPopup({
    required String callId,
    required String callerId,
    required String callerName,
    String? userProfilePic,
  }) {
    
    debugPrint("🎆 ===========================================");
    debugPrint("🎆 DISPLAYING PRIVATE CALL POPUP");
    debugPrint("🎆 Call ID: $callId");
    debugPrint("🎆 Caller: $callerName (ID: $callerId)");
    debugPrint("🎆 Profile Pic: ${userProfilePic ?? 'None'}");
    debugPrint("🎆 Current Route: ${Get.currentRoute}");
    debugPrint("🎆 Dialog Open: ${Get.isDialogOpen}");
    debugPrint("🎆 ===========================================");
    
    // Close any existing dialogs first
    if (Get.isDialogOpen == true) {
      debugPrint("⚠️ Closing existing dialog before showing private call popup");
      Get.back();
      Future.delayed(Duration(milliseconds: 300), () {
        _showPrivateCallDialog(callId, callerId, callerName, userProfilePic);
      });
    } else {
      _showPrivateCallDialog(callId, callerId, callerName, userProfilePic);
    }
  }
  
  /// Internal method to show the actual dialog
  void _showPrivateCallDialog(String callId, String callerId, String callerName, String? userProfilePic) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: userProfilePic != null && userProfilePic.isNotEmpty
                      ? NetworkImage(userProfilePic)
                      : const AssetImage('assets/images/profile.png') as ImageProvider,
                  backgroundColor: Colors.purple.withOpacity(0.3),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.diamond, color: Colors.purple, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Private Call Request',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    callerName,
                    style: const TextStyle(color: Colors.purple, fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$callerName wants to have a private call with you during your live stream.',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.purple, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'This will be a private 1-on-1 call',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Reject Button
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              
              debugPrint("❌ Host declining private call: $callId from $callerName");
              
              final controller = Get.find<CallController>();
              final success = await controller.rejectPrivateCall(callId: callId, reason: 'Host declined');
              
              if (success) {
                debugPrint("✅ Private call successfully rejected");
                Get.snackbar(
                  '❌ Call Declined',
                  'You declined the private call from $callerName',
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                  icon: Icon(Icons.call_end, color: Colors.white),
                );
              } else {
                debugPrint("❌ Failed to reject private call");
                Get.snackbar(
                  '❌ Error',
                  'Failed to decline the call. Please try again.',
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
              }
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
              Get.back(); // Close dialog
              
              // Show loading
              Get.dialog(
                const AlertDialog(
                  backgroundColor: Colors.black87,
                  content: Row(
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
              
              debugPrint("✅ Host accepting private call: $callId from $callerName");
              
              final controller = Get.find<CallController>();
              final result = await controller.acceptPrivateCall(callId: callId);
              
              // Close loading
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              
              if (result != null) {
                debugPrint("✅ ===========================================");
                debugPrint("✅ PRIVATE CALL ACCEPTED SUCCESSFULLY!");
                debugPrint("✅ Result: $result");
                debugPrint("✅ Agora Data: ${result['agora']}");
                debugPrint("✅ Room ID: ${result['agora']?['roomId']}");
                debugPrint("✅ Host Token: ${result['agora']?['host']?['token']?.substring(0, 20)}...");
                debugPrint("✅ ===========================================");
                
                Get.snackbar(
                  '✅ Call Accepted',
                  'Starting private call with $callerName...',
                  backgroundColor: Colors.green.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                  icon: Icon(Icons.videocam, color: Colors.white),
                );
                
                // TODO: Navigate to private call screen with proper data
                final agoraData = result['agora'];
                if (agoraData != null) {
                  debugPrint("📞 Ready to navigate to private call screen:");
                  debugPrint("📞 - Room ID: ${agoraData['roomId']}");
                  debugPrint("📞 - App ID: ${agoraData['appId']}");
                  debugPrint("📞 - Host UID: ${agoraData['host']?['uid']}");
                  debugPrint("📞 - Requester UID: ${agoraData['requester']?['uid']}");
                  
                  // Here you would navigate to private call screen
                  // Get.to(() => PrivateCallScreen(agoraData: agoraData));
                }
              } else {
                debugPrint("❌ Private call acceptance failed - result is null");
                Get.snackbar(
                  '❌ Error',
                  'Failed to accept the private call. Please try again.',
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
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
}
