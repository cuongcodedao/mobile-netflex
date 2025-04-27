import 'package:better_player_plus/better_player_plus.dart';
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
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();

    // Lấy URL từ VideoPlayerController
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.controller.dataSource,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _betterPlayerController);
  }
}
