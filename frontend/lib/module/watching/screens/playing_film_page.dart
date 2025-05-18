import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/models/episode/episode_data.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:frontend/module/watching/widgets/loading_waching.dart';
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

class _PlayingFilmPageState extends State<PlayingFilmPage> with WidgetsBindingObserver {
  BetterPlayerController? _betterPlayerController;
  bool isLoading = true;
  Film? _film;
  EpisodeData? _episode;

  final TextStyle textLarge = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat",
    color: Colors.white,
  );
  final TextStyle textMedium = TextStyle(
    fontSize: 16,
    fontFamily: "Montserrat",
    color: Colors.white,
  );
  final TextStyle headerMedium = TextStyle(
    fontSize: 18,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.slug != null) {
      loadFilm();
    } else if (widget.film != null) {
      setState(() {
        isLoading = false;
      });
      if (widget.episode != null) {
        loadFilmController(widget.episode!.link_m3u8);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App bị ẩn hoặc chuyển trạng thái
      _saveWatchingProgress(false);
    }
  }

  void loadFilm() async {
    Film f = await FilmRepository(ApiService()).getFilm(widget.slug!);
    setState(() {
      _film = f;
      _episode = _film!.listEpisodes[0].serverData[widget.indexSelected];
      isLoading = false;
    });

    loadFilmController(_episode!.link_m3u8);

  }

  void loadFilmController(String linkM3u8) {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      linkM3u8,
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
          textColor: Colors.redAccent,
          progressBarPlayedColor: Colors.redAccent,
          iconsColor: Colors.redAccent,
          loadingColor: Colors.redAccent,
          liveTextColor: Colors.redAccent,
          overflowModalColor: Colors.redAccent,
          overflowMenuIconsColor: Colors.redAccent,
          overflowModalTextColor: Colors.redAccent,
          loadingWidget: Center(
            child: SpinKitCubeGrid(color: Colors.redAccent, size: 50.0),
          ),
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
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        print("🎬 Video finihsed!");
        _saveWatchingProgress(true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveWatchingProgress();
    _betterPlayerController?.dispose();
    super.dispose();
  }

  void _saveWatchingProgress([bool? finish]) async {
    final videoPlayerController =
        _betterPlayerController?.videoPlayerController;

    // Kiểm tra nếu controller không tồn tại
    if (videoPlayerController == null) return;

    final duration = videoPlayerController.value.duration;
    final position = await videoPlayerController.position;

    // Nếu thiếu dữ liệu thì thoát
    if (duration == null || position == null || duration.inSeconds == 0) return;

    final watchingDuration = position.inSeconds;
    final progressPercent = position.inSeconds / duration.inSeconds;

    // Kiểm tra video đã xem xong chưa (chênh lệch <= 1 giây)
    const tolerance = Duration(seconds: 1);
    final isFinished = (duration - position).abs() <= tolerance;

    // Gửi dữ liệu đến server
    bool set = await HistoryRepository(ApiService()).addFilmHistory(
      (widget.slug == null) ? widget.film!.slug : _film!.slug,
      widget.indexSelected,
      (finish != null) ? finish : isFinished,
      watchingDuration,
      // progressPercent, // <-- thêm vào đây nếu API hỗ trợ
    );

    if (set) {
      print(
        "Save film success. Progress: ${progressPercent.toStringAsFixed(2)}",
      );
    } else {
      print("Save film fail");
    }

    _betterPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: LoadingWaching(),
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
                child:
                    _betterPlayerController == null
                        ? Center(
                          child: SpinKitCubeGrid(
                            color: Colors.redAccent,
                            size: 50.0,
                          ),
                        )
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
