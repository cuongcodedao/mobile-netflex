import 'package:flutter/material.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/profile/profile_model.dart';

class HomePage extends StatefulWidget {
  final ProfileModel profile;
  const HomePage({super.key, required this.profile});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FilmRepository filmRepository;
  FilmPage? filmPage;
  List<Film> newFilms = [];
  List<Film> topFilms = [];
  List<Film> forYouFilms = [];
  bool isLoading = true;
  bool isLoadingFail = false;

  @override
  void initState() {
    super.initState();
    filmRepository = FilmRepository(ApiService()); // inject service
    loadFilmPage();
    loadForYouFilms();
    loadNewFilms();
  }

  Future<void> loadFilmPage() async {
    try {
      filmPage = await filmRepository.getFilmPage(1); // truyen lug
    } catch (e) {
      isLoadingFail = true;
      print('Error loading film page: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadForYouFilms() async {
    try {
      final profileId =
          widget.profile.id; // Access profile ID using widget.profile.id
      forYouFilms = await filmRepository.getListFilmByFavorite(
        profileId!,
      ); // Add null check
      setState(() {});
    } catch (e) {
      print('Error loading For You films: $e');
    }
  }

  Future<void> loadNewFilms() async {
    try {
      newFilms = await filmRepository.getNewFilms(); // Add null check
      setState(() {});
    } catch (e) {
      print('Error loading For You films: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isLoadingFail) {
      return Center(
        child: Text(
          "Fail connect",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner lớn trên cùng
          const SizedBox(height: 16),
          FeatureBanner(
            films: List.generate(
              newFilms.length,
              (index) => BannerFilm(
                imageUrl: "https://phimimg.com/${newFilms[index].urlPoster}",
                genres:
                    (newFilms[index].category
                        ?.map((e) => e.name)
                        .whereType<String>()
                        .toList()) ??
                    [],
                onAddToList: () {
                  print('Add to My List Film 1');
                  MyListRepository(
                    ApiService(),
                  ).addMyListFilm(newFilms[index].slug);
                },
                onPlay: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              WatchingScreen(slug: newFilms[index].slug),
                    ),
                  );
                },
                onInfo: () => print('Info Film 1'),
                onTap: () => print('Tap Film 1'),
              ),
            ),
          ),
          // Danh sách TOP 10
          HorizontalFilmList(
            listTitle: 'TOP 10',
            films: List.generate(
              filmPage!.items.length,
              (index) => FilmItem(
                imageUrl: filmPage!.items[index].urlPoster,
                labelType: FilmLabelType.top,
              ),
            ),
            itemHeight: 180,
            itemWidth: 120,
          ),

          // Danh sách NEW EPISODES
          HorizontalFilmList(
            listTitle: 'NEW EPISODES',
            films: List.generate(
              filmPage!.items.length,
              (index) => FilmItem(
                imageUrl: filmPage!.items[index].urlPoster,
                labelType: FilmLabelType.top,
              ),
            ),
          ),

          // Danh sách For You
          HorizontalFilmList(
            listTitle: 'For You',
            films: List.generate(
              forYouFilms.length,
              (index) => FilmItem(
                imageUrl: "https://phimimg.com/${forYouFilms[index].urlPoster}",
                labelType: FilmLabelType.top,
              ),
            ),
          ),

          // Danh sách HUSTLE
          HorizontalFilmList(
            listTitle: 'HUSTLE',
            films: List.generate(
              filmPage!.items.length,
              (index) => FilmItem(
                imageUrl: filmPage!.items[index].urlPoster,
                labelType: FilmLabelType.top,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
