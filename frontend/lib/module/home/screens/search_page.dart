import 'package:flutter/material.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/module/home/widgets/item_search.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FilmRepository filmRepository;
  TextEditingController controller = TextEditingController();
  List<Film> films = [];
  bool isLoading = false;

  void search() {
    isLoading = true;
    loadFilm();
  }

  @override
  void initState() {
    super.initState();
    filmRepository = FilmRepository(ApiService()); // inject service
  }

  Future<void> loadFilm() async {
    try {
      films = await filmRepository.getSearchFilm(controller.text);
    } catch (e) {
      films = [];
      print('Error loading search film page: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SearchBar(
                controller: controller,
                leading: Icon(Icons.search),
                onChanged: (value) {
                  search();
                },
              ),
            ),
            (isLoading)
                ? CircularProgressIndicator()
                : Column(
                  children: List.generate(
                    films.length,
                    (index) => ItemSearch(
                      urlPoster: films[index].urlPoster,
                      name: films[index].name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    WatchingScreen(slug: films[index].slug),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
