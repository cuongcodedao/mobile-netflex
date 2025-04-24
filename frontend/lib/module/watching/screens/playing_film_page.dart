import 'package:flutter/material.dart';
import 'package:frontend/models/episode.dart';
import 'package:frontend/models/film.dart';
import 'package:frontend/module/watching/widgets/custome_play_video.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:video_player/video_player.dart';

class PlayingFilmPage extends StatefulWidget {
  final Film film;
  final Episode episode;
  final int indexSelected;
  const PlayingFilmPage({
    super.key, 
    required this.film,
    required this.episode,
    required this.indexSelected
  });

  @override
  State<PlayingFilmPage> createState() => _PlayingFilmPageState();
}

class _PlayingFilmPageState extends State<PlayingFilmPage> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

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
    _controller = VideoPlayerController.network(
      widget.episode.linkM3u8,
    );
    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      setState(() {});
      _controller!.play();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
              _controller == null
              ? SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator()
                  )
                )
              : FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CustomePlayVideo(
                      controller: _controller!,
                    );
                  } 
                  else {
                    return SizedBox( 
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
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
              padding: const EdgeInsets.symmetric(vertical:20, horizontal: 15),
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
