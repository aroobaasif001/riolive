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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCall();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.leaveChannel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller.engine == null) return;
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
      await controller.initAgora(
        channelName: widget.channelName,
        agoraToken: widget.agoraToken,
        isHost: widget.isHost,
      );
    } catch (e) {
      debugPrint("Agora init failed: $e");
      if (mounted) Get.snackbar("Error", "Init failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _endCall() async {
    if (_ending) return;
    _ending = true;
    try {
      final success = await controller.endCall(widget.token, widget.callId);
      await controller.leaveChannel();
      if (!mounted) return;
      Get.back();
      Get.snackbar(
        success ? "Call Ended" : "Error",
        success ? "Call ended successfully" : "Failed to end call",
      );
    } catch (e) {
      debugPrint("Error ending call: $e");
      if (mounted) {
        Get.back();
        Get.snackbar("Error", e.toString());
      }
    } finally {
      _ending = false;
    }
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
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  children: [
                    // Remote video
                    Obx(() {
                      final uid = controller.remoteUid.value;
                      if (uid != null && controller.engine != null) {
                        return AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: controller.engine!,
                            canvas: VideoCanvas(uid: uid),
                            connection: RtcConnection(
                              channelId: widget.channelName,
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text(
                              "Waiting for participant...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Local preview
                    Positioned(
                      top: 20,
                      right: 20,
                      width: 120,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: controller.engine != null
                            ? AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: controller.engine!,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),

                    // Controls
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              onPressed: _ending ? null : controller.muteUnmute,
                              icon: Obx(
                                () => Icon(
                                  controller.isMuted.value
                                      ? Icons.mic_off
                                      : Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: _ending ? null : _endCall,
                              icon: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              onPressed: _ending
                                  ? null
                                  : controller.switchCamera,
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
                  ],
                ),
              ),
      ),
    );
  }
}
