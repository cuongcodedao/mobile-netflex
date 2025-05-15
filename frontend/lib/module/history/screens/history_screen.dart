import 'package:flutter/material.dart';
import 'package:frontend/models/history/film_history.dart';
import 'package:frontend/module/history/widgets/item_film_continue.dart';
import 'package:frontend/module/history/widgets/item_film_watched.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/history_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<FilmHistory> listHistoryWatched = [];
  List<FilmHistory> listHistoryContinue = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    List<FilmHistory> list =
    await HistoryRepository(ApiService()).getFilmHistory();
    for (var history in list) {
    if (history.finished) {
        listHistoryWatched.add(history);
      } else {
        listHistoryContinue.add(history);
      }
  }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.redAccent,
        title: const Text(
          "Watch History",
          style: TextStyle(
            color: Colors.redAccent,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:
      isLoading
      ? Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 200,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  width: 150,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  width: 130,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 200,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  width: 150,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  width: 130,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
      : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Continue Watching Section
            if (listHistoryContinue.isNotEmpty) ...[
              const Text(
                "Continue Watching",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: listHistoryContinue.length,
                  separatorBuilder:
                (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final film = listHistoryContinue[index];
                    final episode = film.episodeHistory;

                    if (episode == null) return const SizedBox.shrink();

                    return ItemFilmContinue(
                      linearProgress: film.progress,
                      url: episode.posterUrl,
                      nameEspsode: episode.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                          (_) => PlayingFilmPage(
                              slug: episode.slug,
                              watchDuration: film.watchDuration,
                              indexSelected: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],

            // Watched Again Section
            if (listHistoryWatched.isNotEmpty) ...[
              const Text(
                "Watch It Again",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: listHistoryWatched.length,
                  separatorBuilder:
                (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final film = listHistoryWatched[index];
                    final episode = film.episodeHistory;

                    if (episode == null) return const SizedBox.shrink();

                    return ItemFilmContinue(
                      linearProgress: film.progress,
                      url: episode.posterUrl,
                      nameEspsode: episode.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                          (_) => PlayingFilmPage(
                              slug: episode.slug,
                              watchDuration: film.watchDuration,
                              indexSelected: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            if (listHistoryContinue.isEmpty &&
            listHistoryWatched.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "No history yet.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontFamily: "Montserrat",
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
