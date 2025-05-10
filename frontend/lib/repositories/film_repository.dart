import 'package:frontend/models/episode/episode.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class FilmRepository {
  final ApiService apiService;

  FilmRepository(this.apiService);

  Future<Film> getFilm(String slug) async {
    String? accessToken = await StorageService().getAccessToken();
    final response = await apiService.get1(
      '/api/v1/movie/$slug',
      // token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmdAZ21haWwuY29tIiwiaWF0IjoxNzQ2NDE4NTAwLCJleHAiOjE3NDY1MDQ5MDB9.CuFycmZcaXTohc2OFtNLDPQMqOHG8CztbbVf6cd9G8o",
        token: accessToken
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
      String? accessToken = await StorageService().getAccessToken();
      final response = await apiService.get1(
        '/api/v1/movie/search',
        data: {"keyword": keyword},
      // token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmdAZ21haWwuY29tIiwiaWF0IjoxNzQ2NDE4NTAwLCJleHAiOjE3NDY1MDQ5MDB9.CuFycmZcaXTohc2OFtNLDPQMqOHG8CztbbVf6cd9G8o",
        token: accessToken
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
    String? accessToken = await StorageService().getAccessToken();
    final response = await apiService.get1(
      '/api/v1/movie',
      data: {"page": page},
      // token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmdAZ21haWwuY29tIiwiaWF0IjoxNzQ2NDE4NTAwLCJleHAiOjE3NDY1MDQ5MDB9.CuFycmZcaXTohc2OFtNLDPQMqOHG8CztbbVf6cd9G8o",
      token: accessToken
    );

    final result = response.data['result'];
    print("film page" + result.toString());
    final film = FilmPage.fromJson(result);
    return film;
  }
  Future<List<Film>> getListFilmByFavorite(int profileId) async {
    try {
      String? accessToken = await StorageService().getAccessToken();
      final response = await apiService.get1(
        '/api/v1/movie/favorite/$profileId',
      // token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmdAZ21haWwuY29tIiwiaWF0IjoxNzQ2NDE4NTAwLCJleHAiOjE3NDY1MDQ5MDB9.CuFycmZcaXTohc2OFtNLDPQMqOHG8CztbbVf6cd9G8o",
        token: accessToken
      );


      final List<dynamic> results = response.data['result'] ?? [];
      List<Film> films = [];
      for (int i = 0; i < results.length; ++i) {
        films.add(Film.fromJson(results[i]));
      }
      print(films[0].urlPoster);

      print("Số phim tìm được: ${films.length}");
      return films;
    } catch (e) {
      print("Lỗi khi tìm kiếm phim: $e");
      return [];
    }
  }
  
}
