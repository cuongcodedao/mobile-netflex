import 'package:frontend/models/episode/episode.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class FilmRepository {
  final ApiService apiService;

  FilmRepository(this.apiService);

  Future<Film> getFilm(String slug) async {
    final response = await apiService.get(
      '/api/v1/movie/$slug',
    );

    final result = response.data['result'];
    final film = Film.fromJson(result['movie']);

    final episodes =
        (result['episodes'] as List<dynamic>)
            .map((e) => Episode.fromJson(e))
            .toList();

    film.listEpisodes = episodes;
    print("So tap cua phim: " + film.listEpisodes.length.toString());
    return film;
  }

  Future<List<Film>> getSearchFilm(String keyword) async {
    try {
      final response = await apiService.get(
        '/api/v1/movie/search',
        data: {"keyword": keyword},
      );

      print("search: " + response.data['result'].toString());

      final List<dynamic> results = response.data['result'] ?? [];
      print("so phan tu: " + results.length.toString());
      print("type result" + results[0].runtimeType.toString());
      // final films = results.map((e) => Film.fromJson(e)).toList();
      List<Film> films = [];
      for (int i = 0; i < results.length; ++i) {
        films.add(Film.fromJson(results[i]));
      }

      print("Số phim tìm được: ${films.length}");
      return films;
    } catch (e) {
      print("Lỗi khi tìm kiếm phim: $e");
      return [];
    }
  }

  Future<FilmPage> getFilmPage(int page) async {
    final response = await apiService.get(
      '/api/v1/movie',
      data: {"page": page},
    );

    final result = response.data['result'];
    print("film page" + result.toString());
    final film = FilmPage.fromJson(result);
    return film;
  }
}
