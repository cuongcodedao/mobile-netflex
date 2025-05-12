import 'package:flutter/material.dart';
import 'package:frontend/models/episode/episode_data.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/history_repository.dart';
import 'package:frontend/services/api_services.dart';

class PlayingFilmPage extends StatefulWidget {
  final String? slug;
  final Film? film;
  final EpisodeData? episode;
  final int indexSelected;
  final int? watchDuration;
  const PlayingFilmPage({
    super.key,
    this.film,
    this.episode,
    required this.indexSelected,
    this.slug,
    this.watchDuration,
  });

  @override
  State<PlayingFilmPage> createState() => _PlayingFilmPageState();
}

class _PlayingFilmPageState extends State<PlayingFilmPage> {
  BetterPlayerController? _betterPlayerController;
  bool isLoading = true;
  Film? _film;
  EpisodeData? _episode;

  final TextStyle textLarge = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  final TextStyle textMedium = TextStyle(fontSize: 16, color: Colors.white);
  final TextStyle headerMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    if (widget.slug != null) {
      loadFilm();
    } else {
      setState(() {
        isLoading = false;
      });
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.episode!.link_m3u8,
        videoFormat: BetterPlayerVideoFormat.hls,
      );
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          autoPlay: true,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: true,
            enablePlayPause: true,
            enableMute: true,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );
    }
  }

  void loadFilm() async {
    Film f = await FilmRepository(ApiService()).getFilm(widget.slug!);
    setState(() {
      _film = f;
      _episode = _film!.listEpisodes[0].serverData[widget.indexSelected];
      ;
      isLoading = false;
    });
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      _episode!.link_m3u8,
      videoFormat: BetterPlayerVideoFormat.hls,
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: true,
          enablePlayPause: true,
          enableMute: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    _betterPlayerController!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        _betterPlayerController!.seekTo(
          Duration(seconds: widget.watchDuration ?? 0),
        );
      }
    });
  }

  @override
  void dispose() {
    _saveWatchingProgress();
    super.dispose();
  }

  void _saveWatchingProgress() async {
    final videoPlayerController =
        _betterPlayerController?.videoPlayerController;
    final position = await videoPlayerController?.position;
    final duration = videoPlayerController?.value.duration;
    final watchingDuration = position?.inSeconds ?? 0;
    bool isFinished = true;


    // Đảm bảo controller tồn tại
    if (videoPlayerController != null) {
      final duration = videoPlayerController.value.duration;
      final position = await videoPlayerController.position;

      // Kiểm tra video đã xem xong chưa (cho phép chênh lệch nhỏ vài giây)
      const tolerance = Duration(seconds: 1); // cho phép lệch 1 giây
      if (position != null &&
        duration != null &&
        (duration - position).abs() <= tolerance) {
        print("Video đã xem xong");
        isFinished = true;
      } else {
        print("Video chưa xem xong");
        isFinished = false;
      }
    }

    bool set = await HistoryRepository(ApiService()).addFilmHistory(
      (widget.slug == null) ? widget.film!.slug : _film!.slug,
      widget.indexSelected,
      isFinished,
      watchingDuration,
    );
    if (set)
      print("save film success");
    else
      print("save film fail");

    _betterPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
    );
  }

  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _betterPlayerController == null
                  ? const Center(child: CircularProgressIndicator())
                  : BetterPlayer(controller: _betterPlayerController!),
            ),
            const SizedBox(height: 20),

            // Film Info
            Text(
              (widget.slug == null)
                  ? widget.film!.originName
                  : _film!.originName,
              style: textLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              "${(widget.slug == null) ? widget.film!.yearOfRelease : _film!.yearOfRelease}",
              style: textMedium.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 10),

            // Episode & Collection Section
            Divider(color: Colors.grey[700]),
            EpisodesAndCollectionSection(
              film: (widget.slug == null) ? widget.film! : _film!,
              episodeSelected: widget.indexSelected,
            ),
          ],
        ),
      ),
    ),
  );
}
}
