import 'package:dio/dio.dart';
import 'package:frontend/models/episode/episode.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/film/film_page.dart';
import 'package:frontend/services/api_services.dart';

class FilmRepository {
  final ApiService apiService;

  FilmRepository(this.apiService);

  Future<Film> getFilm(String slug) async {
    final response = await apiService.get(
      'api/v1/movie/$slug',
      token:
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmcxMTMwNUBnbWFpbC5jb20iLCJpYXQiOjE3NDU2Nzc3OTgsImV4cCI6MTc0NTc2NDE5OH0.0ohvELOHLIHTy7gS63kJ8JQXFd1cUwc70UiBb1Mi2uQ",
    );

    final result = response.data['result'];
    final film = Film.fromJson(result['movie']);

    final episodes =
        (result['episodes'] as List<dynamic>)
            .map((e) => Episode.fromJson(e))
            .toList();

    print(result['episodes'].toString());
    print("So tap" + episodes.length.toString());

    film.listEpisodes = episodes;
    return film;
  }

  Future<List<Film>> getSearchFilm(String keyword) async {
    final response = await apiService.get(
      'api/v1/movie/search',
      token:
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmcxMTMwNUBnbWFpbC5jb20iLCJpYXQiOjE3NDU2Nzc3OTgsImV4cCI6MTc0NTc2NDE5OH0.0ohvELOHLIHTy7gS63kJ8JQXFd1cUwc70UiBb1Mi2uQ",
    );

    final films =
        (response.data['result'] as List<dynamic>)
            .map((e) => Film.fromJson(e))
            .toList();
    print("so phim tim duoc" + films.length.toString());

    return films;
  }

  Future<FilmPage> getFilmPage(int page) async {
    final response = await apiService.get(
      'api/v1/movie',
      data: {"page": page},
      token:
          "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmcxMTMwNUBnbWFpbC5jb20iLCJpYXQiOjE3NDU2Nzc3OTgsImV4cCI6MTc0NTc2NDE5OH0.0ohvELOHLIHTy7gS63kJ8JQXFd1cUwc70UiBb1Mi2uQ",
    );

    final result = response.data['result'];
    print("film page" + result.toString());
    final film = FilmPage.fromJson(result);
    return film;
  }
}
