import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/random_call_controller.dart';

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

class _VideoCallScreenState extends State<VideoCallScreen>
    with WidgetsBindingObserver {
  final CallController controller = Get.find<CallController>();
  bool _isLoading = true;
  bool _ending = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint(
      "🎬 VideoCallScreen init - CallId: ${widget.callId}, Channel: ${widget.channelName}, IsHost: ${widget.isHost}",
    );
    _initializeCall();
  }

  @override
  void dispose() {
    debugPrint("🎬 VideoCallScreen disposing");
    WidgetsBinding.instance.removeObserver(this);
    if (!_ending) {
      _endCallSilently();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller.engine == null || !_initialized) return;

    debugPrint("📱 App lifecycle changed: $state");
    if (state == AppLifecycleState.paused) {
      controller.engine?.enableLocalVideo(false);
      controller.engine?.stopPreview();
    } else if (state == AppLifecycleState.resumed) {
      controller.engine?.enableLocalVideo(true);
      controller.engine?.startPreview();
    }
  }

  Future<void> _initializeCall() async {
    try {
      debugPrint(
        "🚀 Initializing call with token: ${widget.agoraToken.substring(0, 20)}...",
      );

      await controller.initAgora(
        channelName: widget.channelName,
        agoraToken: widget.agoraToken,
        isHost: widget.isHost,
        isAudience: false, // Both participants are broadcasters in 1-to-1
        callId: widget.callId,
      );

      _initialized = true;
      debugPrint("✅ Call initialized successfully");
    } catch (e) {
      debugPrint("❌ Agora init failed: $e");
      if (mounted) {
        Get.snackbar("Error", "Failed to initialize call: $e");
        Get.back(); // Go back if initialization fails
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _endCall() async {
    if (_ending) return;

    setState(() => _ending = true);
    debugPrint("☎️ Ending call...");

    try {
      // Call the enhanced endCall method
      final success = await controller.endCall(widget.token, widget.callId);

      if (!mounted) return;

      Get.back();
      Get.snackbar(
        success ? "Call Ended" : "Error",
        success ? "Call ended successfully" : "Failed to end call properly",
        backgroundColor: success ? Colors.green : Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ Error ending call: $e");
      if (mounted) {
        Get.back();
        Get.snackbar("Error", "Error ending call: $e");
      }
    }
  }

  // Silent end for dispose (no UI feedback)
  Future<void> _endCallSilently() async {
    try {
      await controller.leaveChannel();
    } catch (e) {
      debugPrint("❌ Silent end error: $e");
    }
  }

  Widget _buildLocalVideoView() {
    if (controller.engine == null) return const SizedBox();

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: controller.engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _buildRemoteVideoView(int uid) {
    if (controller.engine == null) return const SizedBox();

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: controller.engine!,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _endCall();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      "Connecting...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: Stack(
                  children: [
                    // Remote video (full screen)
                    Obx(() {
                      final uid = controller.remoteUid.value;
                      if (uid != null) {
                        return _buildRemoteVideoView(uid);
                      }
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black87,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 20),
                            Text(
                              "Waiting for other participant...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "This may take a few moments",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Local preview (top right)
                    Positioned(
                      top: 20,
                      right: 20,
                      width: 120,
                      height: 160,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildLocalVideoView(),
                        ),
                      ),
                    ),

                    // Call info (top left)
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isHost ? "Host" : "Caller",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Controls (bottom)
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Mute/Unmute
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blue.withOpacity(0.9),
                                child: IconButton(
                                  onPressed: _ending
                                      ? null
                                      : controller.muteUnmute,
                                  icon: Obx(
                                    () => Icon(
                                      controller.isMuted.value
                                          ? Icons.mic_off
                                          : Icons.mic,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // End Call
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.red.withOpacity(0.9),
                                child: IconButton(
                                  onPressed: _ending ? null : _endCall,
                                  icon: _ending
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.call_end,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                ),
                              ),
                            ),

                            // Switch Camera
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.orange.withOpacity(0.9),
                                child: IconButton(
                                  onPressed: _ending
                                      ? null
                                      : controller.switchCamera,
                                  icon: const Icon(
                                    Icons.cameraswitch,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Debug info (only in debug mode)
                    if (false) // Set to true for debugging
                      Positioned(
                        bottom: 120,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Call ID: ${widget.callId}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                "Channel: ${widget.channelName}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  "Remote UID: ${controller.remoteUid.value ?? 'None'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
