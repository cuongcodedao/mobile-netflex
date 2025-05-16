import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/widgets/actions_button.dart';
import 'package:frontend/module/watching/widgets/button_large.dart';
import 'package:frontend/module/watching/widgets/episodes_and_collection_section.dart';
import 'package:frontend/module/watching/widgets/loading_waching.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class WatchingScreen extends StatefulWidget {
  final String slug;
  const WatchingScreen({super.key, required this.slug});

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
    filmRepository = FilmRepository(ApiService());
    loadFilm();
  }

  Future<void> loadFilm() async {
    try {
      final fetchedFilm = await filmRepository.getFilm(widget.slug);
      setState(() {
        film = fetchedFilm;
      });
    } catch (e) {
      print('Error loading film: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:
        (isLoading)
        ? LoadingWaching()
        : (film == null)
        ? Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/404 DinoStyle.gif',
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            ),
          )
        )
        : SingleChildScrollView(
          child: Column(
            children: [
              // Banner with overlay and title
              Stack(
                children: [
                  SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Image.network(
                      film!.urlThumb,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade800,
                          highlightColor: Colors.grey.shade600,
                          child: Container(
                            color: Colors.white,
                            width: 300,
                            height: 300,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/not_found.png', // ảnh thay thế
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Text(
                      film!.originName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Play and download buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ButtonLarge(
                      text: "Play",
                      icons: Icons.play_arrow,
                      colorsBackground: Colors.redAccent,
                      colorsText: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                          (_) => PlayingFilmPage(
                              film: film,
                              episode:
                              film!
                              .listEpisodes[0]
                              .serverData[0],
                              indexSelected: 0,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ButtonLarge(
                      text: "Download",
                      icons: Icons.download,
                      colorsBackground: Colors.grey[800]!,
                      colorsText: Colors.white70,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Film info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${film!.yearOfRelease}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: "Montserrat",
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      film!.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Montserrat",
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActionsButton(
                          text: "My List",
                          icon: Icons.add,
                          onTap: () {
                            MyListRepository(
                              ApiService(),
                            ).addMyListFilm(film!.slug);
                          },
                        ),
                        ActionsButton(
                          text: "Rate",
                          icon: Icons.star_outline,
                          onTap: () {},
                        ),
                        ActionsButton(
                          text: "Share",
                          icon: Icons.share,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Episodes and collection section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EpisodesAndCollectionSection(film: film!),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
