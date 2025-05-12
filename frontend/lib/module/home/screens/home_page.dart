import 'package:flutter/material.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FilmRepository filmRepository;
  FilmPage? filmPage;
  bool isLoading = true;
  bool isLoadingFail = false;

  @override
  void initState() {
    super.initState();
    // filmRepository = ref.read(filmRepositoryProvider);
    filmRepository = FilmRepository(ApiService()); // inject service
    loadFilmPage();
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
              filmPage!.items.length,
              (index) => BannerFilm(
                imageUrl: filmPage!.items[index].urlPoster,
                genres: ['Action', 'Adventure'],
                onAddToList: (){
                  MyListRepository(ApiService()).addMyListFilm(filmPage!.items[index].slug);
                },
                onPlay: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              WatchingScreen(slug: filmPage!.items[index].slug),
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

          // Danh sách UMBRELLA ACADEMY
          HorizontalFilmList(
            listTitle: 'UMBRELLA ACADEMY',
            films: List.generate(
              filmPage!.items.length,
              (index) => FilmItem(
                imageUrl: filmPage!.items[index].urlPoster,
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
