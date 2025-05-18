import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/history/film_history.dart';
import 'package:frontend/models/my_list/my_list_film.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/history_repository.dart';
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
  late final HistoryRepository historyRepository;
  FilmPage? filmPage;
  List<Film> newFilms = [];
  List<Film> topFilms = [];
  List<Film> forYouFilms = [];
  List<FilmHistory> listHistoryContinue = [];
  List<FilmHistory> listHistoryWatched = [];
  List<Film> myList = [];
  bool isLoading = true;
  bool isLoadingFail = false;

  @override
  void initState() {
    super.initState();
    filmRepository = FilmRepository(ApiService()); // inject service
    loadFilmPage();
    loadForYouFilms();
    loadNewFilms();
    loadHistory();
    loadMyList();
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

  Future<void> loadHistory() async {
    List<FilmHistory> list =
        await HistoryRepository(ApiService()).getFilmHistory();
    for (var history in list) {
      if (history.finished) {
        listHistoryWatched.add(history);
      } else {
        listHistoryContinue.add(history);
      }
    }
    setState(() {});
    // hiển thị số lượng phim đã xem và đang xem
    //print("Số phim đã xem: ${listHistoryWatched.length}");
    //print("Số phim đang xem: ${listHistoryContinue.length}");
  }
    Future<void> loadMyList() async {
    List<Film> list = await MyListRepository(ApiService()).getMyListFilm();
    // đảo ngược danh sách
    //list = list.reversed.toList();
    setState(() {
      myList = list;
      isLoading = false;
    });
    print("Số phim trong danh sách của tôi: ${myList.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SpinKitCubeGrid(color: Colors.redAccent, size: 50.0),
      );
    }
    if (isLoadingFail) {
      return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/404 DinoStyle.gif',
            fit: BoxFit.fill,
            width: 300,
            height: 300,
          ),
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
                onAddToList: () async {
                  bool set = await MyListRepository(
                    ApiService(),
                  ).addMyListFilm(newFilms[index].slug);
                  if (set) {
                    showSuccessNotify(context, "Success", "Add to My list");
                    await loadMyList();
                  }
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
            listTitle: 'News',
            films: List.generate(
              filmPage!.items.length,
              (index) => FilmItem(
                imageUrl: filmPage!.items[index].urlPoster,
                labelType: FilmLabelType.newFilm,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchingScreen(
                      slug: filmPage!.items[index].slug,
                    ),
                  ),
                )
              ),
            ),
            itemHeight: 180,
            itemWidth: 120,
          ),

          // Danh sách For You
          HorizontalFilmList(
            listTitle: 'For You',
            films: List.generate(
              forYouFilms.length,
              (index) => FilmItem(
                imageUrl: "https://phimimg.com/${forYouFilms[index].urlPoster}",
                labelType: FilmLabelType.none,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchingScreen(
                      slug: forYouFilms[index].slug,
                    ),
                  ),
                )
              ),
            ),
          ),

          // Danh sách NEW EPISODES
          HorizontalFilmList(
            listTitle: 'Your List',
            films: List.generate(
              myList.length,
              (index) => FilmItem(
                imageUrl: myList[index].urlPoster,
                labelType: FilmLabelType.top,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchingScreen(
                      slug: myList[index].slug,
                    ),
                  ),
                )
              ),
            ),
          ),

          // Danh sách Xem lại
          HorizontalFilmList(
            listTitle: 'Continue Watching',
            films: List.generate(
              listHistoryContinue.length,
              (index) => FilmItem(
                imageUrl: listHistoryContinue[index].episodeHistory?.posterUrl ?? '',
                labelType: FilmLabelType.none,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchingScreen(
                      slug: listHistoryContinue[index].episodeHistory?.slug ?? '',
                    ),
                  ),
                ),
              )
            ),
          ),
          // Danh sách xem lại
          HorizontalFilmList(
            listTitle: 'Watch it Again',
            films: List.generate(
              listHistoryWatched.length,
              (index) => FilmItem(
                imageUrl: listHistoryWatched[index].episodeHistory?.posterUrl ?? '',
                labelType: FilmLabelType.none,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WatchingScreen(
                      slug: listHistoryWatched[index].episodeHistory?.slug ?? '',
                    ),
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
