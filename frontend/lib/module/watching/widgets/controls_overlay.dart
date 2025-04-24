import 'package:flutter/material.dart';
import 'package:frontend/module/watching/widgets/control_button.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const ControlsOverlay({required this.controller});

  void _seekToRelative(VideoPlayerController controller, Duration offset) {
    final newPosition = controller.value.position + offset;
    controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isPlaying ?
      const SizedBox.shrink() :
      Positioned.fill(
      child: Container(
        color: Colors.black26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top bar (add future controls like title, etc.)
            const SizedBox(height: 20),

            // Center controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ControlButton(
                  icon: Icons.replay_10,
                  onPressed:
                      () => _seekToRelative(
                        controller,
                        const Duration(seconds: -10),
                      ),
                ),
                const SizedBox(width: 16),
                ControlButton(
                  icon:
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                  onPressed: () {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  },
                ),
                const SizedBox(width: 16),
                ControlButton(
                  icon: Icons.forward_10,
                  onPressed:
                      () => _seekToRelative(
                        controller,
                        const Duration(seconds: 10),
                      ),
                ),
              ],
            ),

            // Bottom bar (volume + fullscreen)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ControlButton(
                    icon:
                        controller.value.volume > 0
                            ? Icons.volume_up
                            : Icons.volume_off,
                    onPressed: () {
                      controller.setVolume(controller.value.volume > 0 ? 0 : 1);
                    },
                  ),
                  ControlButton(
                    icon: Icons.fullscreen,
                    onPressed: () {
                      // Chưa làm fullscreen, placeholder
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Chưa hỗ trợ fullscreen 😅"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
