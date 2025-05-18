import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/history/film_history.dart';
import 'package:frontend/models/my_list/my_list_film.dart';
import 'package:frontend/module/home/bloc/history_cubit.dart';
import 'package:frontend/module/home/bloc/history_state.dart';
import 'package:frontend/module/home/bloc/my_list_cubit.dart';
import 'package:frontend/module/home/bloc/my_list_state.dart';
import 'package:frontend/module/home/widgets/feature_banner.dart';
import 'package:frontend/module/home/widgets/horizontal_film_list.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/repositories/history_repository.dart';
import 'package:frontend/repositories/my_list_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:get_it/get_it.dart';

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
  }

  Future<void> loadAllData() async {
    setState(() {
      isLoading = true;
      isLoadingFail = false;
    });

    try {
      await Future.wait([
        loadFilmPage1(),
        loadNewFilms(),
        loadForYouFilms(),
        loadHistory(),
        loadMyList(),
      ]);
    } catch (e) {
      print('Error loading data: $e');
      isLoadingFail = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadFilmPage() async {
    try {
      await filmRepository.getFilmPage(1); // truyen lug
    } catch (e) {
      setState(() {
        isLoadingFail = true;
      });
      print('Error loading film page: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<FilmPage?> loadFilmPage1() async {
    try {
      return await filmRepository.getFilmPage(1); // truyen lug
    } catch (e) {
      isLoadingFail = true;
      print('Error loading film page: $e');
      return null;
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
      print('Error loading film page: $e');
    }
  }

  Future<List<Film>> loadForYouFilms1() async {
    try {
      final profileId =
          widget.profile.id; // Access profile ID using widget.profile.id
      return filmRepository.getListFilmByFavorite(profileId!); // Add null check
      setState(() {});
    } catch (e) {
      print('Error loading For You films: $e');
      return [];
    }
  }

  Future<void> loadNewFilms() async {
    try {
      newFilms = await filmRepository.getNewFilms();
      print("Số phim mới: ${newFilms.length}");
    } catch (e) {
      print('Error loading new films: $e');
    }
  }

  Future<List<Film>> loadNewFilms1() async {
    try {
      return await filmRepository.getNewFilms(); // Add null check
    } catch (e) {
      print('Error loading For You films: $e');
      return [];
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

  Future<List<FilmHistory>> loadHistoryWatched() async {
    try {
      List<FilmHistory> list =
          await HistoryRepository(ApiService()).getFilmHistory();
      List<FilmHistory> listWatched = [];
      for (var history in list) {
        if (history.finished) {
          listWatched.add(history);
        }
      }
      return listWatched;
    } catch (e) {
      print('Error loading For You films: $e');
      return [];
    }
  }

  Future<List<FilmHistory>> loadHistoryContinue() async {
    try {
      List<FilmHistory> list =
          await HistoryRepository(ApiService()).getFilmHistory();
      List<FilmHistory> listContinue = [];
      for (var history in list) {
        if (!history.finished) {
          listContinue.add(history);
        }
      }
      return listContinue;
    } catch (e) {
      print('Error loading For You films: $e');
      return [];
    }
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

  Future<List<Film>> loadMyList1() async {
    try {
      return MyListRepository(ApiService()).getMyListFilm(); // Add null check
    } catch (e) {
      print('Error loading For my list films: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder(
            future: loadNewFilms1(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: SpinKitCubeGrid(color: Colors.redAccent, size: 50.0),
                  ),
                );
              } else {
                List<Film>? data = snapshot.data;
                if (data != null && data.isNotEmpty) {
                  return FeatureBanner(
                    films: List.generate(
                      data.length,
                      (index) => BannerFilm(
                        imageUrl:
                            "https://phimimg.com/${data[index].urlPoster}",
                        genres:
                            (data[index].category
                                ?.map((e) => e.name)
                                .whereType<String>()
                                .toList()) ??
                            [],
                        onAddToList: () async {
                          bool set = await MyListRepository(
                            ApiService(),
                          ).addMyListFilm(data[index].slug);
                          if (set) {
                            showSuccessNotify(
                              context,
                              "Success",
                              "Add to My list",
                            );
                            await loadMyList();
                          }
                          GetIt.instance<MyListCubit>().loadMyList();
                        },
                        onPlay: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      WatchingScreen(slug: data[index].slug),
                            ),
                          );
                        },
                        onInfo: () => print('Info Film 1'),
                        onTap: () => print('Tap Film 1'),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
            },
          ),
          // Danh sách TOP 10
          FutureBuilder(
            future: loadNewFilms1(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: SpinKitCubeGrid(color: Colors.redAccent, size: 50.0),
                  ),
                );
              } else {
                List<Film>? data = snapshot.data;
                if (data != null && data.isNotEmpty) {
                  return HorizontalFilmList(
                    listTitle: 'News',
                    films: List.generate(
                      data.length,
                      (index) => FilmItem(
                        imageUrl:
                            "https://phimimg.com/${data[index].urlPoster}",
                        labelType: FilmLabelType.none,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        WatchingScreen(slug: data[index].slug),
                              ),
                            ),
                      ),
                    ),
                    itemHeight: 180,
                    itemWidth: 120,
                  );
                } else {
                  return SizedBox();
                }
              }
            },
          ),

          // Danh sách For You
          FutureBuilder(
            future: loadForYouFilms1(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: SpinKitCubeGrid(color: Colors.redAccent, size: 50.0),
                  ),
                );
              } else {
                List<Film>? data = snapshot.data;
                if (data != null && data.isNotEmpty) {
                  return HorizontalFilmList(
                    listTitle: 'For You',
                    films: List.generate(
                      data.length,
                      (index) => FilmItem(
                        imageUrl:
                            "https://phimimg.com/${data[index].urlPoster}",
                        labelType: FilmLabelType.none,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        WatchingScreen(slug: data[index].slug),
                              ),
                            ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
            },
          ),

          // Danh sách NEW EPISODES
          BlocBuilder<MyListCubit, MyListState>(
            builder: (context, state) {
              return FutureBuilder(
                future: loadMyList1(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: Colors.redAccent,
                          size: 50.0,
                        ),
                      ),
                    );
                  } else {
                    List<Film>? data = snapshot.data;
                      if (data != null && data.isNotEmpty) {
                      return HorizontalFilmList(
                        listTitle: 'Your List',
                        films: List.generate(
                          data.length,
                          (index) => FilmItem(
                            imageUrl: data[index].urlPoster,
                            labelType: FilmLabelType.top,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => WatchingScreen(
                                          slug: data[index].slug,
                                        ),
                                  ),
                                ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }
                },
              );
            },
          ),

          // Danh sách Xem lại
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              return FutureBuilder(
                future: loadHistoryContinue(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: Colors.redAccent,
                          size: 50.0,
                        ),
                      ),
                    );
                  } else {
                    List<FilmHistory>? data = snapshot.data;
                      if (data != null && data.isNotEmpty) {
                      return HorizontalFilmList(
                        listTitle: 'Continue Watching',
                        films: List.generate(
                          data.length,
                          (index) => FilmItem(
                            imageUrl:
                                data[index].episodeHistory?.posterUrl ?? '',
                            labelType: FilmLabelType.none,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => WatchingScreen(
                                          slug:
                                              data[index]
                                                  .episodeHistory
                                                  ?.slug ??
                                              '',
                                        ),
                                  ),
                                ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }
                },
              );
            },
          ),

          // Danh sách xem lại
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              return FutureBuilder(
                future: loadHistoryWatched(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: Colors.redAccent,
                          size: 50.0,
                        ),
                      ),
                    );
                  } else {
                    List<FilmHistory>? data = snapshot.data;
                    if (data != null && data.isNotEmpty) {
                      return HorizontalFilmList(
                        listTitle: 'Watch it Again',
                        films: List.generate(
                          data.length,
                          (index) => FilmItem(
                            imageUrl:
                                data[index].episodeHistory?.posterUrl ?? '',
                            labelType: FilmLabelType.none,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => WatchingScreen(
                                          slug:
                                              data[index]
                                                  .episodeHistory
                                                  ?.slug ??
                                              '',
                                        ),
                                  ),
                                ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}