import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/random_call_controller.dart';
import '../../../../../../services/socket_service.dart';
import '../../../../../../utile/app_url.dart';

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
  
  // ✅ Fixed: Persistent video controllers to prevent glitches
  VideoViewController? _localVideoController;
  VideoViewController? _remoteVideoController;
  
  // ✅ Timer for periodic refresh to prevent hanging
  Timer? _videoRefreshTimer;

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
    
    // ✅ Stop video refresh timer
    _stopVideoRefreshTimer();
    
    // ✅ Clean up video controllers to prevent memory leaks
    _disposeVideoControllers();
    
    if (!_ending) {
      _endCallSilently();
    }
    super.dispose();
  }
  
  /// Dispose video controllers properly
  void _disposeVideoControllers() {
    try {
      _localVideoController?.dispose();
      _localVideoController = null;
      
      _remoteVideoController?.dispose();
      _remoteVideoController = null;
      
      debugPrint("✅ Video controllers disposed properly");
    } catch (e) {
      debugPrint("⚠ Error disposing video controllers: $e");
    }
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
      
      // ✅ Force recreate video views after resume to prevent glitches  
      _refreshVideoViews(forceRecreate: true);
    }
  }
  
  /// Refresh video views to prevent orientation glitches
  void _refreshVideoViews({bool forceRecreate = false}) {
    try {
      if (mounted && _initialized) {
        debugPrint("🔄 Refreshing video views (forceRecreate: $forceRecreate)");
        
        if (forceRecreate) {
          // Force recreate local video controller to fix hanging
          _recreateLocalVideoController();
        } else {
          // Simple refresh
          setState(() {
            // This will trigger a rebuild with fresh video views
          });
        }
      }
    } catch (e) {
      debugPrint("⚠ Error refreshing video views: $e");
    }
  }
  
  /// Force recreate local video controller to fix hanging issues
  Future<void> _recreateLocalVideoController() async {
    try {
      debugPrint("🔄 Force recreating local video controller...");
      
      // Dispose current controller
      _localVideoController?.dispose();
      _localVideoController = null;
      
      // Small delay to let disposal complete
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (controller.engine != null && mounted) {
        // Recreate with fresh settings
        _localVideoController = VideoViewController(
          rtcEngine: controller.engine!,
          canvas: const VideoCanvas(
            uid: 0,
            renderMode: RenderModeType.renderModeHidden,
            mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
          ),
        );
        
        // Trigger rebuild to show new controller
        setState(() {});
        
        debugPrint("✅ Local video controller recreated successfully");
      }
    } catch (e) {
      debugPrint("❌ Error recreating local video controller: $e");
    }
  }
  
  /// Start periodic timer to refresh video and prevent hanging
  void _startVideoRefreshTimer() {
    try {
      // Cancel existing timer if any
      _videoRefreshTimer?.cancel();
      
      // Create new timer that refreshes every 30 seconds to prevent hanging
      _videoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted && _initialized && !_ending) {
          debugPrint("🔄 Periodic video refresh to prevent hanging");
          _refreshVideoViews(forceRecreate: false); // Gentle refresh
        }
      });
      
      debugPrint("✅ Video refresh timer started (30s interval)");
    } catch (e) {
      debugPrint("❌ Error starting video refresh timer: $e");
    }
  }
  
  /// Stop and cleanup video refresh timer
  void _stopVideoRefreshTimer() {
    try {
      _videoRefreshTimer?.cancel();
      _videoRefreshTimer = null;
      debugPrint("✅ Video refresh timer stopped");
    } catch (e) {
      debugPrint("❌ Error stopping video refresh timer: $e");
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

      // ✅ Create video controllers once after Agora initialization
      await _createVideoControllers();

      // ✅ Start periodic refresh timer to prevent hanging
      _startVideoRefreshTimer();

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
  
  /// Create video controllers once to prevent glitches
  Future<void> _createVideoControllers() async {
    try {
      if (controller.engine == null) return;
      
      // Dispose existing controller if any
      _localVideoController?.dispose();
      
      // Create local video controller with enhanced settings
      _localVideoController = VideoViewController(
        rtcEngine: controller.engine!,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden, // Better fit
          mirrorMode: VideoMirrorModeType.videoMirrorModeAuto, // Auto mirror
        ),
      );
      
      // Give the controller time to initialize
      await Future.delayed(const Duration(milliseconds: 100));
      
      debugPrint("✅ Enhanced video controllers created successfully");
    } catch (e) {
      debugPrint("❌ Error creating video controllers: $e");
    }
  }
  
  /// Create remote video controller when remote user joins
  void _createRemoteVideoController(int uid) {
    try {
      if (controller.engine == null) return;
      
      _remoteVideoController?.dispose(); // Dispose previous if exists
      
      _remoteVideoController = VideoViewController.remote(
        rtcEngine: controller.engine!,
        canvas: VideoCanvas(
          uid: uid,
          renderMode: RenderModeType.renderModeHidden, // Better fit
          mirrorMode: VideoMirrorModeType.videoMirrorModeDisabled, // No mirror for remote
        ),
        connection: RtcConnection(channelId: widget.channelName),
      );
      
      debugPrint("✅ Enhanced remote video controller created for UID: $uid");
      
      // Small delay then trigger rebuild to show remote video
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() {});
      });
      
    } catch (e) {
      debugPrint("❌ Error creating remote video controller: $e");
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

      // ✅ Check if host was live streaming and needs to return
      final isHostWasLive = AppUrl.user_role == "host" && widget.isHost;

      if (success) {
        Get.back(); // Exit video call screen
        
        if (isHostWasLive) {
          // ✅ Host was live streaming - reinitialize after small delay
          debugPrint("🔴 Host ending call - will reinitialize live streaming");
          
          Get.snackbar(
            "Call Ended",
            "Call ended. Returning to live streaming...",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );
          
          // Small delay then reinitialize
          Future.delayed(const Duration(milliseconds: 800), () {
            SocketService.to.reinitializeHostLiveStreaming();
          });
        } else {
          // Regular user call end
          Get.snackbar(
            "Call Ended",
            "Call ended successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        Get.back();
        Get.snackbar(
          "Error",
          "Failed to end call properly",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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

  /// Show confirmation dialog before ending call
  Future<bool?> _showEndCallConfirmation() async {
    if (_ending) return false; // Already ending, don't show dialog

    return await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "End Call?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          "Are you sure you want to end this call?",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(result: true);
              await _endCall();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "End Call",
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
  }

  Widget _buildLocalVideoView() {
    // ✅ Fixed: Use persistent controller to prevent glitches
    if (_localVideoController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // ✅ Add double-tap gesture to manually refresh local video if hanging
    return GestureDetector(
      onDoubleTap: () {
        debugPrint("👆 Double tap detected - refreshing local video");
        _refreshVideoViews(forceRecreate: true);
        Get.snackbar(
          "Video Refreshed", 
          "Local video refreshed manually",
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      },
      child: AgoraVideoView(controller: _localVideoController!),
    );
  }

  Widget _buildRemoteVideoView(int uid) {
    // ✅ Create remote controller if needed, or use existing one
    if (_remoteVideoController == null || 
        _remoteVideoController!.canvas.uid != uid) {
      _createRemoteVideoController(uid);
    }

    if (_remoteVideoController == null) {
      return const Center(
        child: Text(
          "Waiting for remote video...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return AgoraVideoView(controller: _remoteVideoController!);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Handle orientation changes to prevent video glitches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized && mounted) {
        final orientation = MediaQuery.of(context).orientation;
        debugPrint("📱 Orientation: $orientation");
        // Small delay to let orientation settle, then force recreate for smooth transition
        Future.delayed(const Duration(milliseconds: 300), () {
          _refreshVideoViews(forceRecreate: true);
        });
      }
    });

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before ending call
        return await _showEndCallConfirmation() ?? false;
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

                  ],
                ),
              ),
      ),
    );
  }
}
