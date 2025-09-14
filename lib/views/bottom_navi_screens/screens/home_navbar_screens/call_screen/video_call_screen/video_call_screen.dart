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
  final int? providedUid; // ✅ Add optional UID for private calls

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
    this.isHost = false,
    this.providedUid, // ✅ Optional UID parameter
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
      debugPrint("🚀 ==========================================");
      debugPrint("🚀 INITIALIZING VIDEO CALL");
      debugPrint("🚀 Channel: ${widget.channelName}");
      debugPrint("🚀 Call ID: ${widget.callId}");
      debugPrint("🚀 Is Host: ${widget.isHost}");
      debugPrint("🚀 Provided UID: ${widget.providedUid} ${widget.providedUid != null ? '(PRIVATE CALL)' : '(RANDOM CALL)'}");
      debugPrint("🚀 Token: ${widget.agoraToken.substring(0, 20)}...");
      debugPrint("🚀 ==========================================");

      await controller.initAgora(
        channelName: widget.channelName,
        agoraToken: widget.agoraToken,
        isHost: widget.isHost,
        isAudience: false, // Both participants are broadcasters in 1-to-1
        callId: widget.callId,
        providedUid: widget.providedUid, // ✅ Use provided UID for private calls
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
      if (controller.engine == null) {
        debugPrint("❌ Cannot create video controllers - RtcEngine is null");
        return;
      }
      
      // ✅ Wait for engine to be fully ready
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Check if engine is still available after delay
      if (controller.engine == null || !controller.isJoined.value) {
        debugPrint("❌ RtcEngine not ready yet - skipping video controller creation");
        return;
      }
      
      // Dispose existing controller if any
      _localVideoController?.dispose();
      
      // ✅ FIX: Setup local video first, then create controller
      await controller.engine!.setupLocalVideo(
        const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
          mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
        ),
      );
      
      // ✅ Wait for setup to complete before creating controller
      await Future.delayed(const Duration(milliseconds: 100));
      
      // ✅ Double-check engine is still available
      if (controller.engine != null) {
        // Create local video controller with enhanced settings
        _localVideoController = VideoViewController(
          rtcEngine: controller.engine!,
          canvas: const VideoCanvas(
            uid: 0,
            renderMode: RenderModeType.renderModeHidden, // Better fit
            mirrorMode: VideoMirrorModeType.videoMirrorModeAuto, // Auto mirror
          ),
        );
        
        debugPrint("✅ Local video setup and controller created successfully");
      } else {
        debugPrint("❌ RtcEngine became null during video controller creation");
      }
      
    } catch (e) {
      debugPrint("❌ Error creating video controllers: $e");
    }
  }
  
  /// Create remote video controller when remote user joins
  void _createRemoteVideoController(int uid) {
    try {
      if (controller.engine == null) {
        debugPrint("❌ Cannot create remote video controller - RtcEngine is null");
        return;
      }
      
      debugPrint("🔄 Creating remote video controller for UID: $uid");
      
      // ✅ Wait a moment for engine to be stable
      Future.delayed(const Duration(milliseconds: 100), () async {
        try {
          // ✅ Double-check engine is still available
          if (controller.engine == null || !mounted) {
            debugPrint("❌ RtcEngine unavailable during remote controller creation");
            return;
          }
          
          _remoteVideoController?.dispose(); // Dispose previous if exists
          
          // ✅ Create remote video controller with null safety
          _remoteVideoController = VideoViewController.remote(
            rtcEngine: controller.engine!,
            canvas: VideoCanvas(
              uid: uid,
              renderMode: RenderModeType.renderModeHidden, // Better fit
              mirrorMode: VideoMirrorModeType.videoMirrorModeDisabled, // No mirror for remote
            ),
            connection: RtcConnection(channelId: widget.channelName),
          );
          
          debugPrint("✅ Remote video controller created successfully for UID: $uid");
          
          // ✅ Wait a moment then trigger rebuild
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted && _remoteVideoController != null) {
            setState(() {});
            debugPrint("✅ Remote video UI updated for UID: $uid");
          }
          
        } catch (e) {
          debugPrint("❌ Error in delayed remote video controller creation: $e");
        }
      });
      
    } catch (e) {
      debugPrint("❌ Error creating remote video controller: $e");
    }
  }

  Future<void> _endCall() async {
    if (_ending) return;

    setState(() => _ending = true);
    debugPrint("🔚 ==========================================");
    debugPrint("🔚 ENDING CALL");
    debugPrint("🔚 Call ID: ${widget.callId}");
    debugPrint("🔚 Channel: ${widget.channelName}");
    debugPrint("🔚 Is Host: ${widget.isHost}");
    debugPrint("🔚 User Role: ${AppUrl.user_role}");
    debugPrint("🔚 Is Private Call: ${widget.providedUid != null}");
    debugPrint("🔚 Token available: ${AppUrl.token.isNotEmpty}");
    debugPrint("🔚 ==========================================");

    try {
      // For private calls, use private call end API
      bool success = false;
      if (widget.providedUid != null) {
        // Private call - use private call end API
        debugPrint("🔚 Ending private call via private call API...");
        debugPrint("🔚 Calling controller.endPrivateCall with callId: ${widget.callId}");
        
        try {
          success = await controller.endPrivateCall(callId: widget.callId);
          debugPrint("🔚 endPrivateCall returned: $success");
        } catch (e) {
          debugPrint("❌ endPrivateCall threw exception: $e");
          success = false;
        }
      } else {
        // Random call - use regular end call API
        debugPrint("🔚 Ending random call via regular API...");
        try {
          success = await controller.endCall(widget.token, widget.callId);
          debugPrint("🔚 endCall returned: $success");
        } catch (e) {
          debugPrint("❌ endCall threw exception: $e");
          success = false;
        }
      }

      debugPrint("🔚 API call completed, success: $success");

      if (!mounted) {
        debugPrint("🔚 Widget not mounted, skipping UI updates");
        return;
      }

      // ✅ CRITICAL: Always leave Agora channel regardless of API success
      debugPrint("🔚 Leaving Agora channel...");
      try {
        await controller.leaveChannel();
        debugPrint("✅ Agora channel left successfully");
      } catch (e) {
        debugPrint("⚠ Error leaving Agora channel: $e");
      }

      // ✅ Check if host was live streaming and needs to return
      final isHostWasLive = AppUrl.user_role == "host" && widget.isHost;
      debugPrint("🔚 Is host was live: $isHostWasLive");

      // ✅ ALWAYS navigate back from video call screen
      debugPrint("🔚 Navigating back from video call screen...");
      Get.back(); // Exit video call screen

      if (success) {
        debugPrint("✅ Call ended successfully");
        
        if (isHostWasLive) {
          // ✅ Host was live streaming - show dialog to continue or stop
          debugPrint("🔴 Host ending call - showing continue dialog");
          
          Future.delayed(const Duration(milliseconds: 300), () {
            _showHostContinueDialog();
          });
        } else {
          // Regular user call end
          debugPrint("👤 User call ended successfully");
          Get.snackbar(
            "✅ Call Ended",
            "Call ended successfully",
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        debugPrint("❌ Call end API failed, but forcing exit");
        Get.snackbar(
          "⚠ Call Ended",
          "Call ended (API error but locally disconnected)",
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("❌ Critical error ending call: $e");
      debugPrint("❌ Error type: ${e.runtimeType}");
      debugPrint("❌ Stack trace: ${StackTrace.current}");
      
      // ✅ Force exit even on error
      try {
        await controller.leaveChannel();
      } catch (_) {}
      
      if (mounted) {
        Get.back();
        Get.snackbar(
          "❌ Error", 
          "Error ending call, but disconnected locally",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      // ✅ CRITICAL: Always reset _ending flag
      if (mounted) {
        setState(() => _ending = false);
        debugPrint("🔄 _ending flag reset to false");
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
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black54,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 8),
              Text(
                "Loading camera...",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
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
      child: _buildSafeAgoraVideoView(_localVideoController!),
    );
  }
  
  /// Build AgoraVideoView with error handling
  Widget _buildSafeAgoraVideoView(VideoViewController controller) {
    try {
      return AgoraVideoView(controller: controller);
    } catch (e) {
      debugPrint("❌ Error rendering AgoraVideoView: $e");
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white54, size: 32),
              SizedBox(height: 8),
              Text(
                "Video render error",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildRemoteVideoView(int uid) {
    // ✅ Create remote controller if needed, or use existing one
    if (_remoteVideoController == null || 
        _remoteVideoController!.canvas.uid != uid) {
      _createRemoteVideoController(uid);
    }

    // ✅ Enhanced null safety check
    if (_remoteVideoController == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                "Setting up video connection...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Use safe rendering method
    return _buildSafeAgoraVideoView(_remoteVideoController!);
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

  /// Show dialog to host asking if they want to continue live streaming
  Future<void> _showHostContinueDialog() async {
    try {
      final bool? continueStreaming = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.live_tv, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Continue Live Stream?',
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
              const Text(
                'Your private call has ended. What would you like to do?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.play_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Continue: Resume live streaming to receive more calls',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.stop_circle, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Stop: End live streaming and go back',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                '⚫ Stop Streaming',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                '🔴 Continue Streaming',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (continueStreaming == true) {
        debugPrint("🔴 Host chose to continue live streaming");
        await _continueLiveStreaming();
      } else {
        debugPrint("⚫ Host chose to stop live streaming");
        await _stopLiveStreamingAndExit();
      }

    } catch (e) {
      debugPrint("❌ Error showing host continue dialog: $e");
      // Fallback: just continue streaming
      await _continueLiveStreaming();
    }
  }

  /// Continue live streaming after private call ends
  Future<void> _continueLiveStreaming() async {
    try {
      debugPrint("🔄 Continuing live streaming after private call...");
      
      // ✅ Reinitialize host live streaming
      await SocketService.to.reinitializeHostLiveStreaming();
      
      Get.snackbar(
        '🔴 Live Stream Continued',
        'You are back live and ready for new calls!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.live_tv, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      
      debugPrint("✅ Live streaming continuation completed");
      
    } catch (e) {
      debugPrint("❌ Error continuing live streaming: $e");
      
      Get.snackbar(
        '❌ Continue Error',
        'Failed to continue live streaming. Please restart manually.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Stop live streaming and navigate back properly
  Future<void> _stopLiveStreamingAndExit() async {
    try {
      debugPrint("⚫ Stopping live streaming and exiting...");
      
      // ✅ Remove host from calls
      await SocketService.to.removeHostFromCalls();
      
      Get.snackbar(
        '⚫ Live Stream Ended',
        'Your live stream has been stopped',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // ✅ Navigate back twice as requested
      Future.delayed(const Duration(milliseconds: 500), () {
        debugPrint("🔙 Navigating back from live streaming screen");
        
        // Check if we're on live streaming screen and go back
        if (Get.currentRoute.contains('HostStartLiveStreamingScreen')) {
          Get.back(); // Go back from live streaming screen
        }
        
        // Additional back navigation after delay
        Future.delayed(const Duration(milliseconds: 300), () {
          try {
            Get.back(); // Second back navigation as requested
          } catch (e) {
            debugPrint("⚠ Could not navigate back twice: $e");
          }
        });
      });
      
      debugPrint("✅ Live streaming stop and navigation completed");
      
    } catch (e) {
      debugPrint("❌ Error stopping live streaming: $e");
      
      // Fallback navigation
      try {
        Get.back();
      } catch (e) {
        debugPrint("⚠ Could not navigate back: $e");
      }
    }
  }
}
