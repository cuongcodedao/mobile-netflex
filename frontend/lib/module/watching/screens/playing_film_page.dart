import 'package:flutter/material.dart';
import 'package:frontend/models/episode/episode_data.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:frontend/repositories/history_repository.dart';
import 'package:frontend/services/api_services.dart';

class PlayingFilmPage extends StatefulWidget {
  final Film film;
  final EpisodeData episode;
  final int indexSelected;
  const PlayingFilmPage({
    super.key,
    required this.film,
    required this.episode,
    required this.indexSelected,
  });

  @override
  State<PlayingFilmPage> createState() => _PlayingFilmPageState();
}

class _PlayingFilmPageState extends State<PlayingFilmPage> {
  BetterPlayerController? _betterPlayerController;

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
    print("So tap cua phim: " + widget.film.listEpisodes.length.toString());
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.episode.link_m3u8,
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

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _saveWatchingProgress();
    super.dispose();
  }

  void _saveWatchingProgress() async {
    final videoPlayerController =
        _betterPlayerController?.videoPlayerController;
    final position = await videoPlayerController?.position;
    final duration = await videoPlayerController?.value.duration;
    final watchingDuration = position?.inSeconds ?? 0;
    bool isFinished = true;

    if (position != null && duration != null) {
      final hasEnded = position >= duration;
      if (hasEnded) {
        isFinished = true;
      } else {
        isFinished = false;
      }
    }

    // Gọi API hoặc lưu local ở đây
    bool set = await HistoryRepository(ApiService()).addFilmHistory(
      widget.film.slug,
      widget.indexSelected,
      isFinished,
      watchingDuration,
    );
    if (set)
      print("save film success");
    else
      print("save film fail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child:
                  _betterPlayerController == null
                      ? SizedBox(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer(
                          controller: _betterPlayerController!,
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(widget.film.originName, style: textLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        widget.film.yearOfRelease.toString(),
                        style: textMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "S5:E10 Nothing Remains The Same",
                        style: headerMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: EpisodesAndCollectionSection(
                film: widget.film,
                episodeSelected: widget.indexSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
