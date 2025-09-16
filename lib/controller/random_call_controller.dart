import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../services/socket_service.dart';
import '../utile/app_url.dart';

class CallController extends GetxController {
  static const String fallbackAppId = "747241138f01491291af0d34b78a5e9c";

  var isLoading = false.obs;
  RtcEngine? engine;
  var remoteUid = RxnInt();
  var isMuted = false.obs;
  var isJoined = false.obs;
  var isPreviewStarted = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  
  // ✅ Filter properties
  var currentFilter = 'none'.obs;
  var isFilterEnabled = false.obs;
  var beautyLevel = 0.5.obs;
  var smoothnessLevel = 0.5.obs;
  var brightnessLevel = 0.0.obs;

  String? channel;
  String? _currentToken;
  String? _serverAppId;
  int _uid = 0;
  bool _tearingDown = false;
  RtcEngineEventHandler? _handler;

  int _deriveUid() {
    final parsed = int.tryParse(AppUrl.riolive_id.toString());
    return parsed ?? 0;
  }

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
    String? appId,
    bool isHost = false,
    bool isAudience = false,
    required String callId,
    int? providedUid,
  }) async {
    try {
      debugPrint(
        "Initializing Agora with channel: $channelName, isHost: $isHost",
      );

      final mic = await Permission.microphone.request();
      final cam = await Permission.camera.request();
      if (!mic.isGranted || !cam.isGranted) {
        Get.snackbar("Permission Denied", "Camera & Microphone are required");
        return;
      }

      if (engine != null) {
        await leaveChannel();
      }

      channel = channelName;
      _currentToken = agoraToken;
      _uid = providedUid ?? _deriveUid();
      
      if (providedUid != null) {
        debugPrint("🔧 Using provided UID: $providedUid (PRIVATE CALL - BACKEND MATCH)");
      } else {
        debugPrint("🔧 Using derived UID: $_uid (RANDOM CALL - DEFAULT)");
      }

      // Use provided appId or fallback
      if (appId != null && appId.isNotEmpty) {
        _serverAppId = appId;
      }

      engine = createAgoraRtcEngine();
      final appIdToUse = _serverAppId ?? fallbackAppId;

      debugPrint("Using App ID: $appIdToUse");

      await engine!.initialize(RtcEngineContext(appId: appIdToUse));

      // Enable video and set encoder configuration
      await engine!.enableVideo();
      await engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 960, height: 540),
          frameRate: 15,
          bitrate: 0,
        ),
      );

      // Set channel profile and client role
      await engine!.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting,
      );

      final clientRole = isAudience
          ? ClientRoleType.clientRoleAudience
          : ClientRoleType.clientRoleBroadcaster;

      await engine!.setClientRole(role: clientRole);

      // Setup event handlers
      _handler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
            "✅ Joined ${connection.channelId} uid=${connection.localUid}",
          );
          isJoined.value = true;
          hasError.value = false;
          errorMessage.value = '';

          // If host, start preview
          if (!isAudience) {
            _startPreview();
          }
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("Remote user joined: $uid");
          remoteUid.value = uid;
          
          // ✅ CLEAN: Let VideoCallScreen handle video setup, just ensure subscription
          Future.delayed(Duration(milliseconds: 200), () async {
            try {
              // Just ensure video is not muted - let VideoViewController handle setup
              await engine?.muteRemoteVideoStream(uid: uid, mute: false);
              debugPrint("✅ Remote video unmuted for UID: $uid");
            } catch (e) {
              debugPrint("⚠ Remote video unmute warning: $e");
            }
          });
        },
        onUserOffline: (RtcConnection _, int uid, UserOfflineReasonType __) {
          debugPrint("Remote user offline: $uid");
          remoteUid.value = null;
        },
        onLeaveChannel: (RtcConnection _, RtcStats __) {
          debugPrint("Left channel");
          isJoined.value = false;
          isPreviewStarted.value = false;
          remoteUid.value = null;
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora error: $err, message: $msg");
          hasError.value = true;
          errorMessage.value = "Error: $err - $msg";
          _handleAgoraError(err, isAudience);
        },
        onRequestToken: (RtcConnection _) {
          _handleTokenRefreshRequest(isAudience);
        },
        onTokenPrivilegeWillExpire: (RtcConnection _, String __) {
          _handleTokenRefreshRequest(isAudience);
        },
      );

      engine!.registerEventHandler(_handler!);

      // Join channel
      await engine!.joinChannel(
        token: _currentToken!,
        channelId: channel!,
        uid: _uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: clientRole,
          publishCameraTrack: !isAudience,
          publishMicrophoneTrack: !isAudience,
          // ✅ FIX: Enable video subscription for private calls
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
        ),
      );
    } catch (e) {
      debugPrint("Agora init error: $e");
      hasError.value = true;
      errorMessage.value = "Initialization failed: $e";
      Get.snackbar("Error", "Agora init failed: $e");
    }
  }

  Future<void> _startPreview() async {
    try {
      // ✅ CLEAN: Only start preview, let VideoViewController handle setupLocalVideo
      await engine!.startPreview();
      isPreviewStarted.value = true;
      debugPrint("Local preview started");
    } catch (e) {
      debugPrint("Failed to start preview: $e");
    }
  }

  void _handleTokenRefreshRequest(bool isAudience) async {
    if (channel == null) return;
    try {
      final newToken = await fetchAgoraToken(
        token: AppUrl.token,
        channelName: channel!,
        uid: _uid,
        role: isAudience ? 'audience' : 'host',
      );
      if (newToken?.isNotEmpty == true) {
        _currentToken = newToken;
        await engine?.renewToken(newToken!);
      }
    } catch (e) {
      debugPrint("Token refresh error: $e");
    }
  }

  void _handleAgoraError(ErrorCodeType err, bool isAudience) async {
    debugPrint("Agora error [$err]");

    // Handle token errors
    if (err == ErrorCodeType.errInvalidToken ||
        err == ErrorCodeType.errTokenExpired) {
      debugPrint("Token is invalid or expired, trying to refresh...");

      if (channel == null) return;
      try {
        final newToken = await fetchAgoraToken(
          token: AppUrl.token,
          channelName: channel!,
          uid: _uid,
          role: isAudience ? 'audience' : 'host',
        );

        if (newToken?.isNotEmpty == true) {
          _currentToken = newToken;
          await engine?.renewToken(newToken!);

          // Rejoin channel with new token
          await engine?.leaveChannel();
          await Future.delayed(Duration(milliseconds: 500));

          final clientRole = isAudience
              ? ClientRoleType.clientRoleAudience
              : ClientRoleType.clientRoleBroadcaster;

          await engine?.joinChannel(
            token: newToken!,
            channelId: channel!,
            uid: _uid,
            options: ChannelMediaOptions(
              channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
              clientRoleType: clientRole,
              publishCameraTrack: !isAudience,
              publishMicrophoneTrack: !isAudience,
            ),
          );
        } else {
          debugPrint("Failed to get new token");
          errorMessage.value = "Failed to refresh token. Please try again.";
        }
      } catch (e) {
        debugPrint("Token error handling failed: $e");
        errorMessage.value = "Token refresh failed: $e";
      }
    }
  }

  Future<void> leaveChannel() async {
    if (engine == null || _tearingDown) return;
    _tearingDown = true;
    try {
      await engine?.stopPreview();
      await engine?.leaveChannel();
      await Future.delayed(const Duration(milliseconds: 300));
      if (_handler != null) {
        engine?.unregisterEventHandler(_handler!);
      }
      await engine?.release();
    } catch (e) {
      debugPrint("leaveChannel error: $e");
    } finally {
      engine = null;
      _handler = null;
      remoteUid.value = null;
      isJoined.value = false;
      isPreviewStarted.value = false;
      _tearingDown = false;
    }
  }

  void muteUnmute() {
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
  }

  void switchCamera() {
    if (_tearingDown) return;
    engine?.switchCamera();
  }

  // ================== API CALLS ==================

  Future<Map<String, dynamic>?> startCall(String token) async {
    try {
      isLoading.value = true;
      
      // ✅ Check network connectivity first
      debugPrint("🌐 Checking network connectivity...");
      final networkOk = await _checkNetworkConnectivity();
      
      if (!networkOk) {
        debugPrint("❌ Network connectivity failed");
        Get.snackbar("Network Error", "Please check your internet connection and try again");
        return null;
      }
      
      // ✅ Wake up server if sleeping
      debugPrint("⏰ Waking up server...");
      await _wakeUpServer();
      
      // ✅ Check available live hosts before starting call
      debugPrint("📋 Checking available live hosts...");
      await _printAvailableLiveHosts();
      
      // ✅ Wait for socket connection
      debugPrint("🚀 Starting random call - checking socket connection...");
      final socketReady = await SocketService.to.waitForConnection(timeoutSeconds: 20);
      
      if (!socketReady) {
        debugPrint("❌ Socket connection failed - force reconnecting...");
        
        // Try force reconnect
        final reconnectSuccess = await SocketService.to.forceReconnect(timeoutSeconds: 15);
        
        if (!reconnectSuccess) {
          debugPrint("❌ Force reconnect also failed");
          Get.snackbar(
            "Connection Error", 
            "Unable to connect to server. Please check your internet connection and try again.",
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
        
        debugPrint("✅ Force reconnect successful");
      }
      
      debugPrint("✅ Socket ready - making API call to start call");
      final res = await http.post(
        Uri.parse(AppUrl.startVideoCall),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Start call API timeout', Duration(seconds: 30));
        },
      );

      debugPrint("📥 Start call response - Status: ${res.statusCode}");
      debugPrint("📥 Start call response - Body: ${res.body}");
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;
        
        debugPrint("✅ Start call successful - Data: $data");
        return data;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ Start call failed - Status: ${res.statusCode}, Body: $body");
        Get.snackbar("Error", body['message'] ?? "Start call failed");
      }
    } catch (e) {
      debugPrint("💥 Start call exception: $e");
      Get.snackbar("Error", "Failed to start call: ${e.toString()}");
    } finally {
      debugPrint("🏁 Start call finished - Loading: false");
      isLoading.value = false;
    }
    return null;
  }

  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    try {
      isLoading.value = true;
      debugPrint("🤝 Joining call - CallId: $callId");
      
      final res = await http.post(
        Uri.parse("${AppUrl.joinVideoCall}$callId"),
        headers: {"Authorization": "Bearer $token"},
      );
      
      debugPrint("📥 Join call response - Status: ${res.statusCode}");
      debugPrint("📥 Join call response - Body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;
        return data;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "Join call failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<bool> endCall(String token, String callId, {bool showErrors = true}) async {
    try {
      debugPrint("🔚 Starting call end process - CallId: $callId, User: ${AppUrl.user_name}, Role: ${AppUrl.user_role}");
      
      final res = await http.post(
        Uri.parse("${AppUrl.endVideoCall}$callId"),
        headers: {"Authorization": "Bearer $token"},
      );
      
      debugPrint("📥 End call response - Status: ${res.statusCode}");
      debugPrint("📥 End call response - Body: ${res.body}");
      
      if (res.statusCode == 200) {
        // ✅ Enhanced socket notification for call end coordination
        SocketService.to.socket?.emit("call_ended", {
          "callId": callId,
          "userId": AppUrl.riolive_id,
          "userName": AppUrl.user_name,
          "userRole": AppUrl.user_role,
          "endedBy": AppUrl.user_role, // user or host
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "reason": "user_ended"
        });
        
        debugPrint("📤 Emitted call_ended event to coordinate both sides");
        
        // ✅ Also call existing notification method  
        SocketService.to.notifyCallEnded({
          "callId": callId,
          "userId": AppUrl.riolive_id,
        });
        
        debugPrint("✅ Call end successful - Both parties should be notified");
        return true;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ End call failed - Status: ${res.statusCode}, Body: $body");
        if (showErrors) {
          Get.snackbar("Error", body['message'] ?? "End call failed");
        }
      }
    } catch (e) {
      debugPrint("💥 End call exception: $e");
      if (showErrors) {
        Get.snackbar("Error", "Failed to end call: ${e.toString()}");
      }
    }
    return false;
  }

  Future<bool> rejectCall(String token, String callId) async {
    try {
      final res = await http.post(
        Uri.parse("${AppUrl.rejectVideoCall}$callId"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        debugPrint("✅ Call rejected successfully");
        return true;
      } else {
        final body = jsonDecode(res.body);
        Get.snackbar("Error", body['message'] ?? "Reject call failed");
      }
    } catch (e) {
      debugPrint("RejectCall error: $e");
      Get.snackbar("Error", e.toString());
    }
    return false;
  }

  Future<Map<String, dynamic>?> startLiveCall(String token) async {
    try {
      isLoading.value = true;
      debugPrint("🔴 Calling startLiveCall API to register host as live...");
      debugPrint("🔴 Endpoint: ${AppUrl.goLiveCall}");
      debugPrint("🔴 Token: ${token.substring(0, 20)}...");
      
      final res = await http.post(
        Uri.parse(AppUrl.goLiveCall),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": "Available for calls", 
          "description": "Host is live and available for random calls"
        }),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Start live API timeout', Duration(seconds: 15));
        },
      );
      
      debugPrint("🔴 StartLive API response - Status: ${res.statusCode}");
      debugPrint("🔴 StartLive API response - Body: ${res.body}");
      
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        _serverAppId = data['agora']?['appId']?.toString() ?? _serverAppId;
        debugPrint("✅ Host successfully registered as live - Data: $data");
        return data;
      } else {
        final body = jsonDecode(res.body);
        debugPrint("❌ StartLive API failed - Status: ${res.statusCode}, Body: $body");
        // Don't show snackbar for API errors to avoid disrupting UX
        debugPrint("❌ Start live failed: ${body['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      debugPrint("💥 StartLive API exception: $e");
      // Don't show snackbar for exceptions to avoid disrupting UX
      debugPrint("❌ Failed to register host as live: ${e.toString()}");
    } finally {
      debugPrint("🏁 StartLive API finished - Loading: false");
      isLoading.value = false;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getLiveHosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/hosts/live-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['hosts'] != null) {
          final hosts = List<Map<String, dynamic>>.from(data['hosts']);
          return hosts;
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching live hosts: $e');
      return [];
    }
  }

  Future<String?> fetchAgoraToken({
    required String token,
    required String channelName,
    required int uid,
    String role = 'host',
  }) async {
    try {
      final uri = Uri.parse(
        "${AppUrl.agoraToken}?channel=$channelName&uid=$uid&role=$role",
      );
      final res = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'success' && data['agora'] != null) {
          return data['agora']['token']?.toString();
        }
      } else {
        debugPrint("Token fetch failed with status: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("fetchAgoraToken error: $e");
    }
    return null;
  }

  // ================== FILTER METHODS ==================
  
  /// Apply beauty filter with custom parameters
  Future<void> applyBeautyFilter({
    double? beauty,
    double? smoothness, 
    double? brightness,
  }) async {
    try {
      if (engine == null) {
        debugPrint("❌ Agora engine not initialized for filters");
        return;
      }
      
      final beautyValue = beauty ?? beautyLevel.value;
      final smoothnessValue = smoothness ?? smoothnessLevel.value;
      final brightnessValue = brightness ?? brightnessLevel.value;
      
      debugPrint("🎨 Applying beauty filter - Beauty: $beautyValue, Smoothness: $smoothnessValue, Brightness: $brightnessValue");
      
      await engine!.setBeautyEffectOptions(
        enabled: true,
        options: BeautyOptions(
          lighteningContrastLevel: LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: brightnessValue,
          smoothnessLevel: smoothnessValue,
          rednessLevel: beautyValue * 0.2, // Subtle redness
        ),
      );
      
      currentFilter.value = 'beauty';
      isFilterEnabled.value = true;
      beautyLevel.value = beautyValue;
      smoothnessLevel.value = smoothnessValue;
      brightnessLevel.value = brightnessValue;
      
      debugPrint("✅ Beauty filter applied successfully");
      
    } catch (e) {
      debugPrint("❌ Error applying beauty filter: $e");
    }
  }
  
  /// Apply color enhancement filter
  Future<void> applyColorFilter(String filterType) async {
    try {
      if (engine == null) {
        debugPrint("❌ Agora engine not initialized for filters");
        return;
      }
      
      debugPrint("🎨 Applying color filter: $filterType");
      
      switch (filterType) {
        case 'vintage':
          await engine!.setColorEnhanceOptions(
            enabled: true,
            options: const ColorEnhanceOptions(
              strengthLevel: 0.6,
              skinProtectLevel: 0.8,
            ),
          );
          break;
        case 'cool':
          await engine!.setColorEnhanceOptions(
            enabled: true,
            options: const ColorEnhanceOptions(
              strengthLevel: 0.4,
              skinProtectLevel: 0.9,
            ),
          );
          break;
        case 'warm':
          await engine!.setColorEnhanceOptions(
            enabled: true,
            options: const ColorEnhanceOptions(
              strengthLevel: 0.7,
              skinProtectLevel: 0.7,
            ),
          );
          break;
        case 'none':
          await engine!.setColorEnhanceOptions(
            enabled: false,
            options: const ColorEnhanceOptions(
              strengthLevel: 0.0,
              skinProtectLevel: 1.0,
            ),
          );
          break;
      }
      
      currentFilter.value = filterType;
      isFilterEnabled.value = filterType != 'none';
      
      debugPrint("✅ Color filter '$filterType' applied successfully");
      
    } catch (e) {
      debugPrint("❌ Error applying color filter: $e");
    }
  }
  
  /// Remove all filters
  Future<void> removeAllFilters() async {
    try {
      if (engine == null) {
        debugPrint("❌ Agora engine not initialized");
        return;
      }
      
      debugPrint("🔄 Removing all filters");
      
      // Disable beauty effects
      await engine!.setBeautyEffectOptions(
        enabled: false,
        options: const BeautyOptions(),
      );
      
      // Disable color enhancement
      await engine!.setColorEnhanceOptions(
        enabled: false,
        options: const ColorEnhanceOptions(),
      );
      
      currentFilter.value = 'none';
      isFilterEnabled.value = false;
      
      debugPrint("✅ All filters removed successfully");
      
    } catch (e) {
      debugPrint("❌ Error removing filters: $e");
    }
  }
  
  /// Toggle filter on/off
  Future<void> toggleFilters() async {
    if (isFilterEnabled.value) {
      await removeAllFilters();
    } else {
      await applyBeautyFilter(); // Apply default beauty filter
    }
  }

  // ================== PRIVATE CALL METHODS ==================
  
  /// Request a private call to a host
  Future<Map<String, dynamic>?> requestPrivateCall({
    required int hostId,
    required String hostName,
    String? randomCallId,
  }) async {
    try {
      debugPrint("📞 ===========================================");
      debugPrint("📞 REQUESTING PRIVATE CALL");
      debugPrint("📞 ===========================================");
      debugPrint("📞 Target Host: $hostName (ID: $hostId)");
      debugPrint("📞 Current User: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("📞 User Role: ${AppUrl.user_role}");
      
      // ✅ Validation checks
      if (AppUrl.token?.isEmpty ?? true) {
        debugPrint("❌ Authentication token not available");
        throw Exception('Authentication token not available');
      }

      if (hostId == AppUrl.riolive_id) {
        debugPrint("❌ Cannot request private call to yourself");
        throw Exception('Cannot request private call to yourself');
      }

      if (AppUrl.user_role == 'host') {
        debugPrint("⚠️ Host requesting private call to another host");
      }

      // Generate randomCallId if not provided (for debugging)
      final callId = randomCallId ?? 'private_call_${DateTime.now().millisecondsSinceEpoch}';
      
      final requestBody = {
        'hostId': hostId,
        'randomCallId': callId,
      };
      
      debugPrint("📞 ===========================================");
      debugPrint("📞 REQUEST DETAILS:");
      debugPrint("📞 URL: ${AppUrl.privateCallRequest}");
      debugPrint("📞 Method: POST");
      debugPrint("📞 Headers: Content-Type: application/json");
      debugPrint("📞 Auth: Bearer ${AppUrl.token?.substring(0, 20)}...");
      debugPrint("📞 Body: ${json.encode(requestBody)}");
      debugPrint("📞 Timeout: 15 seconds");
      debugPrint("📞 ===========================================");
      
      final response = await http.post(
        Uri.parse(AppUrl.privateCallRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppUrl.token}',
        },
        body: json.encode(requestBody),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Private call request timeout after 15 seconds');
        },
      );

      debugPrint("📞 ===========================================");
      debugPrint("📞 RESPONSE RECEIVED:");
      debugPrint("📞 Status Code: ${response.statusCode}");
      debugPrint("📞 Response Headers: ${response.headers}");
      debugPrint("📞 Response Body: ${response.body}");
      debugPrint("📞 ===========================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        debugPrint("✅ ===========================================");
        debugPrint("✅ PRIVATE CALL REQUEST SUCCESSFUL!");
        debugPrint("✅ Response Status: ${data['status']}");
        debugPrint("✅ Message: ${data['message']}");
        debugPrint("✅ Private Call ID: ${data['privateCall']?['id']}");
        debugPrint("✅ Private Call Status: ${data['privateCall']?['status']}");
        debugPrint("✅ Debug Info: ${data['debug']}");
        debugPrint("✅ Backend should emit to room: ${data['debug']?['hostRoomId']}");
        debugPrint("✅ Target host is live: ${data['debug']?['hostIsLive']}");
        debugPrint("✅ ===========================================");
        
        // ✅ CRITICAL: Join user to private call room to receive accepted/rejected events
        final privateCallId = data['privateCall']?['id']?.toString();
        if (privateCallId != null) {
          debugPrint("🏠 ===========================================");
          debugPrint("🏠 JOINING USER TO PRIVATE CALL ROOM");
          debugPrint("🏠 Private Call ID: $privateCallId");
          debugPrint("🏠 User ID: ${AppUrl.riolive_id}");
          debugPrint("🏠 Socket Connected: ${SocketService.to.isConnected.value}");
          debugPrint("🏠 ===========================================");
          
          _joinUserToPrivateCallRoom(privateCallId);
        } else {
          debugPrint("❌ Cannot join room - Private Call ID missing");
        }
        
        return data;
      } else {
        debugPrint("❌ ===========================================");
        debugPrint("❌ PRIVATE CALL REQUEST FAILED!");
        debugPrint("❌ HTTP Status: ${response.statusCode}");
        debugPrint("❌ Response: ${response.body}");
        
        // Try to parse error details
        try {
          final errorData = json.decode(response.body);
          debugPrint("❌ Error Status: ${errorData['status']}");
          debugPrint("❌ Error Message: ${errorData['message']}");
          debugPrint("❌ Error Details: ${errorData['error']}");
          
          if (errorData['message'] != null) {
            throw Exception('Backend Error: ${errorData['message']}');
          }
        } catch (parseError) {
          debugPrint("❌ Could not parse error response: $parseError");
        }
        debugPrint("❌ ===========================================");
        
        throw Exception('Private call request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("💥 ===========================================");
      debugPrint("💥 PRIVATE CALL REQUEST EXCEPTION!");
      debugPrint("💥 Error Type: ${e.runtimeType}");
      debugPrint("💥 Error Message: $e");
      debugPrint("💥 Stack Trace: ${StackTrace.current}");
      debugPrint("💥 Host ID: $hostId");
      debugPrint("💥 Host Name: $hostName");
      debugPrint("💥 User ID: ${AppUrl.riolive_id}");
      debugPrint("💥 User Role: ${AppUrl.user_role}");
      debugPrint("💥 Token Available: ${AppUrl.token?.isNotEmpty ?? false}");
      debugPrint("💥 ===========================================");
      
      // Re-throw with more context
      throw Exception('Private call request failed: $e');
    }
  }

  /// Accept a private call request
  Future<Map<String, dynamic>?> acceptPrivateCall({
    required String callId,
  }) async {
    try {
      debugPrint("✅ Accepting private call: $callId");
      
      if (AppUrl.token?.isEmpty ?? true) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('${AppUrl.privateCallAccept}$callId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppUrl.token}',
        },
      );

      debugPrint("✅ Accept private call response - Status: ${response.statusCode}");
      debugPrint("✅ Accept private call response - Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("✅ Private call accepted successfully - Data: $data");
        return data;
      } else {
        debugPrint("❌ Accept private call failed: ${response.statusCode} - ${response.body}");
        throw Exception('Accept private call failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error accepting private call: $e");
      return null;
    }
  }

  /// Reject a private call request
  Future<bool> rejectPrivateCall({
    required String callId,
    String? reason,
  }) async {
    try {
      debugPrint("❌ ===========================================");
      debugPrint("❌ REJECTING PRIVATE CALL");
      debugPrint("❌ Call ID: $callId");
      debugPrint("❌ Host ID: ${AppUrl.riolive_id}");
      debugPrint("❌ Reason: ${reason ?? 'Host declined'}");
      debugPrint("❌ Token Available: ${AppUrl.token?.isNotEmpty ?? false}");
      debugPrint("❌ ===========================================");
      
      if (AppUrl.token?.isEmpty ?? true) {
        debugPrint("❌ Authentication token not available");
        throw Exception('Authentication token not available');
      }

      final url = '${AppUrl.privateCallReject}$callId';
      debugPrint("❌ REQUEST DETAILS:");
      debugPrint("❌ URL: $url");
      debugPrint("❌ Method: POST");
      debugPrint("❌ Headers: Content-Type: application/json");
      debugPrint("❌ Auth: Bearer ${AppUrl.token?.substring(0, 20)}...");
      debugPrint("❌ Body: ${json.encode({'reason': reason ?? 'Host declined'})}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppUrl.token}',
        },
        body: json.encode({
          'reason': reason ?? 'Host declined',
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint("⏰ Private call reject request timed out after 10 seconds");
          throw Exception('Request timeout after 10 seconds');
        },
      );

      debugPrint("❌ ===========================================");
      debugPrint("❌ RESPONSE RECEIVED:");
      debugPrint("❌ Status Code: ${response.statusCode}");
      debugPrint("❌ Response Headers: ${response.headers}");
      debugPrint("❌ Response Body: ${response.body}");
      debugPrint("❌ ===========================================");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint("✅ ===========================================");
        debugPrint("✅ PRIVATE CALL REJECTED SUCCESSFULLY!");
        debugPrint("✅ Response Data: $responseData");
        debugPrint("✅ Status: ${responseData['status']}");
        debugPrint("✅ Message: ${responseData['message']}");
        debugPrint("✅ ===========================================");
        
        // Backend should emit "private_call_status" event with status: "rejected"
        debugPrint("📤 Backend should emit private_call_status event to notify requester");
        return true;
      } else {
        debugPrint("❌ ===========================================");
        debugPrint("❌ PRIVATE CALL REJECT FAILED!");
        debugPrint("❌ Status Code: ${response.statusCode}");
        debugPrint("❌ Error Body: ${response.body}");
        debugPrint("❌ ===========================================");
        
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Unknown error';
          debugPrint("❌ Server Error Message: $errorMessage");
        } catch (e) {
          debugPrint("❌ Could not parse error response: $e");
        }
        
        return false;
      }
    } catch (e) {
      debugPrint("💥 ===========================================");
      debugPrint("💥 PRIVATE CALL REJECT EXCEPTION!");
      debugPrint("💥 Error Type: ${e.runtimeType}");
      debugPrint("💥 Error Message: $e");
      debugPrint("💥 Stack Trace: ${StackTrace.current}");
      debugPrint("💥 Call ID: $callId");
      debugPrint("💥 Host ID: ${AppUrl.riolive_id}");
      debugPrint("💥 Token Available: ${AppUrl.token?.isNotEmpty ?? false}");
      debugPrint("💥 ===========================================");
      return false;
    }
  }

  /// End an active private call
  Future<bool> endPrivateCall({
    required String callId,
  }) async {
    try {
      debugPrint("🔚 ==========================================");
      debugPrint("🔚 ENDING PRIVATE CALL");
      debugPrint("🔚 ==========================================");
      debugPrint("🔚 Call ID: $callId");
      debugPrint("🔚 Current User: ${AppUrl.user_name} (ID: ${AppUrl.riolive_id})");
      debugPrint("🔚 User Role: ${AppUrl.user_role}");
      debugPrint("🔚 Token Available: ${AppUrl.token?.isNotEmpty ?? false}");
      debugPrint("🔚 Token Preview: ${AppUrl.token?.substring(0, 20) ?? 'null'}...");
      debugPrint("🔚 ==========================================");
      
      if (AppUrl.token?.isEmpty ?? true) {
        debugPrint("❌ Authentication token not available");
        throw Exception('Authentication token not available');
      }

      if (callId.isEmpty) {
        debugPrint("❌ Call ID is empty");
        throw Exception('Call ID is required');
      }

      final url = '${AppUrl.privateCallEnd}$callId';
      debugPrint("🔚 REQUEST DETAILS:");
      debugPrint("🔚 URL: $url");
      debugPrint("🔚 Method: POST");
      debugPrint("🔚 Headers: Content-Type: application/json");
      debugPrint("🔚 Auth: Bearer ${AppUrl.token?.substring(0, 20)}...");
      debugPrint("🔚 Timeout: 10 seconds");
      debugPrint("🔚 ==========================================");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppUrl.token}',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint("⏰ Private call end request timed out after 10 seconds");
          throw Exception('Request timeout after 10 seconds');
        },
      );

      debugPrint("🔚 ==========================================");
      debugPrint("🔚 RESPONSE RECEIVED:");
      debugPrint("🔚 Status Code: ${response.statusCode}");
      debugPrint("🔚 Response Headers: ${response.headers}");
      debugPrint("🔚 Response Body: ${response.body}");
      debugPrint("🔚 ==========================================");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint("✅ ==========================================");
        debugPrint("✅ PRIVATE CALL ENDED SUCCESSFULLY!");
        debugPrint("✅ Response Data: $responseData");
        debugPrint("✅ Status: ${responseData['status']}");
        debugPrint("✅ Message: ${responseData['message']}");
        debugPrint("✅ ==========================================");
        return true;
      } else {
        debugPrint("❌ ==========================================");
        debugPrint("❌ PRIVATE CALL END FAILED!");
        debugPrint("❌ Status Code: ${response.statusCode}");
        debugPrint("❌ Error Body: ${response.body}");
        debugPrint("❌ ==========================================");
        
        // Try to parse error message
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Unknown error';
          debugPrint("❌ Server Error Message: $errorMessage");
        } catch (e) {
          debugPrint("❌ Could not parse error response: $e");
        }
        
        return false;
      }
    } catch (e) {
      debugPrint("💥 ==========================================");
      debugPrint("💥 PRIVATE CALL END EXCEPTION!");
      debugPrint("💥 Error Type: ${e.runtimeType}");
      debugPrint("💥 Error Message: $e");
      debugPrint("💥 Stack Trace: ${StackTrace.current}");
      debugPrint("💥 Call ID: $callId");
      debugPrint("💥 User ID: ${AppUrl.riolive_id}");
      debugPrint("💥 User Role: ${AppUrl.user_role}");
      debugPrint("💥 Token Available: ${AppUrl.token?.isNotEmpty ?? false}");
      debugPrint("💥 ==========================================");
      return false;
    }
  }

  // ================== PRIVATE CALL HELPERS ==================
  
  /// Join user to private call room to receive accept/reject events
  void _joinUserToPrivateCallRoom(String privateCallId) {
    try {
      if (!SocketService.to.isConnected.value) {
        debugPrint("❌ Socket not connected - cannot join private call room");
        return;
      }
      
      // Generate consistent room names that backend uses
      final userRoomId = "user_room_${AppUrl.riolive_id}_$privateCallId";
      final privateCallRoom = "private_call_room_$privateCallId";
      final requesterRoom = "requester_room_${AppUrl.riolive_id}";
      
      debugPrint("🏠 Joining user to multiple room formats:");
      debugPrint("🏠 - User Room: $userRoomId");
      debugPrint("🏠 - Private Call Room: $privateCallRoom");
      debugPrint("🏠 - Requester Room: $requesterRoom");
      
      // Method 1: Direct socket join with room ID
      SocketService.to.socket?.emit("join_room", {
        "roomId": userRoomId,
        "userId": AppUrl.riolive_id,
        "role": "user",
        "privateCallId": privateCallId
      });
      
      // Method 2: Join private call specific room
      SocketService.to.socket?.emit("join_room", {
        "roomId": privateCallRoom,
        "userId": AppUrl.riolive_id,
        "role": "requester"
      });
      
      // Method 3: Requester specific room
      SocketService.to.socket?.emit("join_room", {
        "roomId": requesterRoom,
        "userId": AppUrl.riolive_id,
        "role": "requester"
      });
      
      // Method 4: Alternative join format
      SocketService.to.socket?.emit("join", {"room": userRoomId});
      SocketService.to.socket?.emit("join", {"room": privateCallRoom});
      SocketService.to.socket?.emit("join", {"room": requesterRoom});
      
      debugPrint("✅ User joined private call rooms for receiving events");
      
      // Debug: Show user room status after 2 seconds
      Timer(Duration(seconds: 2), () {
        _debugUserRoomStatus(privateCallId);
      });
      
    } catch (e) {
      debugPrint("❌ Error joining user to private call room: $e");
    }
  }

  /// Debug user socket room status
  void _debugUserRoomStatus(String privateCallId) {
    try {
      debugPrint("🔍 ===========================================");
      debugPrint("🔍 DEBUG: USER SOCKET ROOM STATUS");
      debugPrint("🔍 Private Call ID: $privateCallId");
      debugPrint("🔍 User ID: ${AppUrl.riolive_id}");
      debugPrint("🔍 Socket Connected: ${SocketService.to.isConnected.value}");
      debugPrint("🔍 Socket ID: ${SocketService.to.socket?.id}");
      debugPrint("🔍 ===========================================");
      
      // Try to emit a test message to verify room membership
      SocketService.to.socket?.emit("test_user_in_room", {
        "privateCallId": privateCallId,
        "userId": AppUrl.riolive_id,
        "message": "Testing if user is in private call room"
      });
      
      debugPrint("🔍 Sent test message to verify room membership");
      
    } catch (e) {
      debugPrint("❌ Error debugging user room status: $e");
    }
  }

  // ================== NETWORK HELPERS ==================
  
  /// Check network connectivity
  Future<bool> _checkNetworkConnectivity() async {
    try {
      debugPrint("🔍 Testing network connectivity...");
      
      // Try to resolve DNS first
      final result = await InternetAddress.lookup('google.com');
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint("✅ Network connectivity OK");
        return true;
      }
    } catch (e) {
      debugPrint("❌ Network connectivity failed: $e");
    }
    
    return false;
  }
  
  /// Wake up Render server (free tier sleeps after 30min)
  Future<void> _wakeUpServer() async {
    try {
      debugPrint("⏰ Attempting to wake up Render server...");
      
      // Simple GET request to wake up the server
      final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/health"),
        headers: {"User-Agent": "RioLive-WakeUp"},
      ).timeout(Duration(seconds: 15));
      
      debugPrint("⏰ Server wake up response: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 404) {
        // Even 404 means server is awake
        debugPrint("✅ Server is awake");
        await Future.delayed(Duration(seconds: 2)); // Give server time to fully wake up
      }
      
    } catch (e) {
      debugPrint("⚠ Server wake up failed (might already be awake): $e");
      // Don't throw error - server might already be awake
    }
  }
  
  /// Print available live hosts for debugging
  Future<void> _printAvailableLiveHosts() async {
    try {
      debugPrint("📋 Fetching available live hosts...");
      
      // Try multiple endpoints to find live hosts
      final endpoints = [
        AppUrl.liveListCall,           // /api/hosts/live-list
        AppUrl.availableHostsCall,     // /api/hosts/available  
        AppUrl.liveHostsCall,          // /api/random/calls/hosts
      ];
      
      for (String endpoint in endpoints) {
        try {
          debugPrint("📋 Trying endpoint: $endpoint");
          
          final response = await http.get(
            Uri.parse(endpoint),
            headers: {"Authorization": "Bearer ${AppUrl.token}"},
          ).timeout(Duration(seconds: 10));
          
          debugPrint("📋 Response from $endpoint - Status: ${response.statusCode}");
          debugPrint("📋 Response Body: ${response.body}");
          
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            
            // Extract hosts from different response formats
            final hosts = _extractHostsFromResponse(data, endpoint);
            
            if (hosts.isNotEmpty) {
              debugPrint("📋 ✅ Found ${hosts.length} live hosts:");
              for (int i = 0; i < hosts.length; i++) {
                final host = hosts[i];
                debugPrint("📋   Host ${i + 1}:");
                debugPrint("📋     - ID: ${host['id'] ?? host['hostId'] ?? 'unknown'}");
                debugPrint("📋     - Name: ${host['username'] ?? host['name'] ?? host['hostName'] ?? 'unknown'}");
                debugPrint("📋     - Room ID: ${host['room_id'] ?? host['roomId'] ?? 'unknown'}");
                debugPrint("📋     - Is Live: ${host['is_live'] ?? host['isLive'] ?? host['status'] ?? 'unknown'}");
                debugPrint("📋     - Role: ${host['role'] ?? 'unknown'}");
              }
              
              return; // Success - no need to try other endpoints
            } else {
              debugPrint("📋 ⚠ Endpoint worked but no live hosts found");
            }
          }
          
        } catch (e) {
          debugPrint("📋 ❌ Endpoint $endpoint failed: $e");
          continue; // Try next endpoint
        }
      }
      
      debugPrint("📋 ❌ All endpoints failed or no live hosts found");
      
    } catch (e) {
      debugPrint("📋 ❌ Error fetching live hosts: $e");
    }
  }
  
  /// Extract hosts from different API response formats
  List<Map<String, dynamic>> _extractHostsFromResponse(dynamic data, String endpoint) {
    try {
      List<Map<String, dynamic>> hosts = [];
      
      // Handle different response structures
      if (data is Map<String, dynamic>) {
        // Format 1: {hosts: [...]}
        if (data['hosts'] is List) {
          hosts = List<Map<String, dynamic>>.from(data['hosts']);
        }
        // Format 2: {data: [...]}
        else if (data['data'] is List) {
          hosts = List<Map<String, dynamic>>.from(data['data']);
        }
        // Format 3: {liveHosts: [...]}
        else if (data['liveHosts'] is List) {
          hosts = List<Map<String, dynamic>>.from(data['liveHosts']);
        }
        // Format 4: {users: [...]} or {livestreams: [...]}
        else if (data['users'] is List) {
          hosts = List<Map<String, dynamic>>.from(data['users']);
        }
        else if (data['livestreams'] is List) {
          hosts = List<Map<String, dynamic>>.from(data['livestreams']);
        }
      }
      // Format 5: Direct array
      else if (data is List) {
        hosts = List<Map<String, dynamic>>.from(data);
      }
      
      debugPrint("📋 Extracted ${hosts.length} hosts from response format");
      return hosts;
      
    } catch (e) {
      debugPrint("📋 ❌ Error extracting hosts from response: $e");
      return [];
    }
  }
  
  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }
}
