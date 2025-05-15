import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/item_search.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FilmRepository filmRepository;
  final TextEditingController controller = TextEditingController();
  List<Film> films = [];
  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    filmRepository = FilmRepository(ApiService());
  }

  void search() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = true;
      });
      loadFilm();
    });
  }

  Future<void> loadFilm() async {
    try {
      films = await filmRepository.getSearchFilm(controller.text.trim());
    } catch (e) {
      films = [];
      debugPrint('Error loading search film page: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Custom Search Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.white),
                hintText: "Search for films...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                search();
              },
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child:
                // Loading indicator
                (isLoading)
                    ? ListView.builder(
                      itemCount: 6,
                      itemBuilder:
                          (_, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade800,
                              highlightColor: Colors.grey.shade600,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 30,
                              width: 200,
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 30,
                              width: 200,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                            ),
                          ),
                    )
                    :
                    // No result text
                    (films.isEmpty && controller.text.isNotEmpty)
                    ? const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "No results found.",
                        style: TextStyle(color: Colors.white60, fontSize: 18),
                      ),
                    )
                    // List of films
                    : Expanded(
                      child: ListView.separated(
                        itemCount: films.length,
                        itemBuilder: (context, index) {
                          final film = films[index];
                          return ItemSearch(
                            urlPoster: "https://phimimg.com/${film.urlPoster}",
                            name: film.name,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => WatchingScreen(slug: film.slug),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
