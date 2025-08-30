import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  final String token;
  final String callId;
  final String channelName;
  final String agoraToken;
  final bool isHost;

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
    this.isHost = false,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallController controller = Get.find<CallController>();
  Timer? _pollingTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      await controller.initAgora(
        channelName: widget.channelName,
        agoraToken: widget.agoraToken,
      );

      // If this is a host (live stream), start polling for incoming calls
      if (widget.isHost) {
        _startPollingForIncomingCalls();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to initialize video call: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startPollingForIncomingCalls() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final res = await http.get(
          Uri.parse(
            'https://backend-api-six-drab.vercel.app/api/random/calls/latest',
          ),
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Content-Type": "application/json",
          },
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);

          if (data != null && data['incoming'] == true) {
            final callId = data['callId'].toString();
            final callerName = data['callerName'] ?? "Random User";

            // Stop polling once popup is shown
            _pollingTimer?.cancel();

            Get.dialog(
              AlertDialog(
                title: const Text("Incoming Call"),
                content: Text("You have a call from $callerName"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // reject
                      _startPollingForIncomingCalls(); // resume polling
                    },
                    child: const Text("Reject"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Get.back(); // close popup

                      // Join the incoming random call
                      final joinData = await controller.joinCall(
                        widget.token,
                        callId,
                      );

                      if (joinData != null) {
                        final channelName = joinData['agora']['channelName'];
                        final agoraToken =
                            joinData['agora']['callerToken'] ??
                            joinData['agora']['token'];

                        // Re-init Agora with new details
                        await controller.leaveChannel();
                        await controller.initAgora(
                          channelName: channelName,
                          agoraToken: agoraToken,
                        );
                      }

                      // Resume polling again (optional)
                      _startPollingForIncomingCalls();
                    },
                    child: const Text("Accept"),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        debugPrint("Polling error: $e");
      }
    });
  }

  Future<void> _endCall() async {
    try {
      final success = await controller.endCall(widget.token, widget.callId);

      if (success) {
        Get.back();
        Get.snackbar("Call Ended", "Call ended successfully");
      } else {
        Get.back();
        Get.snackbar("Error", "Failed to end call");
      }

      await controller.leaveChannel();
    } catch (e) {
      debugPrint("Error ending call: $e");
      Get.back();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  // Remote user video
                  Obx(
                    () => controller.remoteUid.value != null
                        ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: controller.engine!,
                              canvas: VideoCanvas(
                                uid: controller.remoteUid.value,
                              ),
                              connection: RtcConnection(
                                channelId: widget.channelName,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 20),
                                  Text(
                                    widget.isHost
                                        ? "Waiting for participants to join..."
                                        : "Connecting to call...",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),

                  // Local preview
                  Positioned(
                    top: 20,
                    right: 20,
                    width: 120,
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: controller.engine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),

                  // Call info header
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.videocam,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isHost ? "Live Stream" : "Random Call",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Call controls
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mute/Unmute
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            onPressed: () => controller.muteUnmute(),
                            icon: Obx(
                              () => Icon(
                                controller.isMuted.value
                                    ? Icons.mic_off
                                    : Icons.mic,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        // End Call
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            onPressed: _endCall,
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),

                        // Switch Camera
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange,
                          child: IconButton(
                            onPressed: () => controller.switchCamera(),
                            icon: const Icon(
                              Icons.cameraswitch,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _endCall,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CallController extends GetxController {
  static const String appId = "6660b35538257de9b67a8b7e6926e1";

  var isLoading = false.obs;
  RtcEngine? engine;
  var remoteUid = RxnInt();
  var isReady = false.obs;
  var isMuted = false.obs;

  Future<void> initAgora({
    required String channelName,
    required String agoraToken,
  }) async {
    try {
      await [Permission.microphone, Permission.camera].request();

      engine = createAgoraRtcEngine();
      await engine?.initialize(RtcEngineContext(appId: appId));

      engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            isReady.value = true;
          },
          onUserJoined: (connection, uid, elapsed) {
            remoteUid.value = uid;
          },
          onUserOffline: (connection, uid, reason) {
            remoteUid.value = null;
          },
          onError: (error, msg) {
            debugPrint("Agora Error: $error, $msg");
          },
        ),
      );

      await engine?.enableVideo();
      await engine?.startPreview();

      await engine?.joinChannel(
        token: agoraToken,
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      debugPrint("Agora initialization error: $e");
      rethrow;
    }
  }

  Future<void> leaveChannel() async {
    try {
      await engine?.leaveChannel();
      await engine?.release();
      engine = null;
      isReady.value = false;
      remoteUid.value = null;
    } catch (e) {
      debugPrint("Error leaving channel: $e");
    }
  }

  void muteUnmute() {
    isMuted.value = !isMuted.value;
    engine?.muteLocalAudioStream(isMuted.value);
  }

  void switchCamera() {
    engine?.switchCamera();
  }

  Future<Map<String, dynamic>?> startCall(String token) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(
          'https://backend-api-six-drab.vercel.app/api/random/call/start',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Get.snackbar("Error", "Failed to start call: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> joinCall(String token, String callId) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(
          'https://backend-api-six-drab.vercel.app/api/random/call/join/$callId',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Get.snackbar("Error", "Failed to join call: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> endCall(String token, String callId) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://backend-api-six-drab.vercel.app/api/random/call/end/$callId',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("EndCall error: $e");
      return false;
    }
  }

  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }
}
