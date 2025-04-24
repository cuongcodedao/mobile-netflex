import 'package:flutter/material.dart';
import 'package:frontend/module/watching/widgets/controls_overlay.dart';
import 'package:video_player/video_player.dart';

class CustomePlayVideo extends StatefulWidget {
  VideoPlayerController controller;
  CustomePlayVideo({super.key, required this.controller});

  @override
  State<CustomePlayVideo> createState() => _CustomePlayVideoState();
}

class _CustomePlayVideoState extends State<CustomePlayVideo> {
  bool _showControls = true;
  bool _isFullscreen = false;



  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  // void _toggleFullscreen() {
  //   setState(() => _isFullscreen = !_isFullscreen);
  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (_) => FullscreenPlayerPage(controller: widget.controller),
  //   ));
  // }

  void _rewind() {
    final position = widget.controller.value.position;
    widget.controller.seekTo(position - const Duration(seconds: 10));
  }

  void _forward() {
    final position = widget.controller.value.position;
    widget.controller.seekTo(position + const Duration(seconds: 10));
  }

  String _formatDuration(Duration d) =>
      "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller),
          ),
          if (_showControls) ...[
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: _rewind, icon: const Icon(Icons.replay_10, color: Colors.white)),
                        IconButton(
                          icon: Icon(
                            widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.controller.value.isPlaying
                                  ? widget.controller.pause()
                                  : widget.controller.play();
                            });
                          },
                        ),
                        IconButton(onPressed: _forward, icon: const Icon(Icons.forward_10, color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _formatDuration(widget.controller.value.position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: widget.controller.value.position.inSeconds.toDouble(),
                            max: widget.controller.value.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              widget.controller.seekTo(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Text(
                          _formatDuration(widget.controller.value.duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white),
                          // onPressed: _toggleFullscreen,
                          onPressed: (){},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }}
