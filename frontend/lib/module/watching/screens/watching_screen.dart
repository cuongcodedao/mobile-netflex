import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/watching/widgets/actions_button.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:frontend/module/watching/widgets/film_info.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';

class WatchingScreen extends StatefulWidget {
  final String slug;
  const WatchingScreen({
    super.key,
    required this.slug
  });

  @override
  State<WatchingScreen> createState() => _WatchingScreenState();
}

class _WatchingScreenState extends State<WatchingScreen> {
  late final FilmRepository filmRepository;
  Film? film;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filmRepository = FilmRepository(ApiService()); // inject service
    loadFilm();
  }

  Future<void> loadFilm() async {
    try {
      Film filmt = await filmRepository.getFilm(widget.slug);;
      setState(() {
        film = filmt;
      });
      if(film != null){
        print("So tap cua phim: "+ film!.listEpisodes.length.toString());
      }
    } catch (e) {
      print('Error loading film: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260,
              color: Colors.blue,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.network(film!.urlThumb),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: FilmInfo(film: film!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ActionsButton(text: "My List", icon: Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ActionsButton(text: "Rate", icon: Icons.handshake),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ActionsButton(text: "Share", icon: Icons.share),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: EpisodesAndCollectionSection(film: film!),
            ),
          ],
        ),
      ),
    );
  }
}
