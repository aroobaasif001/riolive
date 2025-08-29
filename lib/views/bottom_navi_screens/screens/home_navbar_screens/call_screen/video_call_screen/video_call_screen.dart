import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/random_call_controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String token;
  final String callId;
  final String channelName;
  final String agoraToken;

  const VideoCallScreen({
    super.key,
    required this.token,
    required this.callId,
    required this.channelName,
    required this.agoraToken,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallController _controller = CallController();
  int? _remoteUid;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _controller.initAgora(
      channelName: widget.channelName,
      agoraToken: widget.agoraToken,
      onRemoteJoined: (uid) => setState(() => _remoteUid = uid),
      onRemoteLeft: (uid) => setState(() => _remoteUid = null),
    );
    setState(() => _isReady = true); // Agora engine ready
  }

  @override
  void dispose() {
    _controller.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller.engine == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Remote user
            _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _controller.engine!,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  )
                : const Center(child: Text("Waiting for remote user...")),

            // Local preview (top-left corner)
            Positioned(
              top: 40,
              left: 20,
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _controller.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            ),

            // End Call Button (center bottom)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    final success = await _controller.endCall(
                      widget.token,
                      widget.callId,
                    );

                    if (success) {
                      Get.snackbar("Call", "Call ended successfully");
                    } else {
                      Get.snackbar("Error", "Failed to end call");
                    }

                    await _controller.leaveChannel();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.call_end,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
