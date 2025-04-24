import 'package:dio/dio.dart';
import 'package:frontend/models/episode.dart';
import 'package:frontend/models/film.dart';
import 'package:frontend/services/api_services.dart';

class FilmRepository {
  final ApiService apiService;

  FilmRepository(this.apiService);

  Future<Film> getFilm() async {
    final response = await apiService.get(
      'phim/ngoi-truong-xac-song?fbclid=IwY2xjawJsmnVleHRuA2FlbQIxMAABHq8LIcjX8qvks9PoHKO62WOOw3K37KodxLcLANLHhYfQaBg1-rk1KiOBz7X6_aem_sAtHUsjF2U_Q3ca8T5WO6A',
    );

    print(response.data['movie'].toString());
    Film film = Film.fromJson(response.data['movie']); 
    
    final List<dynamic> serverData = response.data['episodes'][0]['server_data'];
    print(serverData.toString());

    List<Episode> allEpisodes = [];

    for(var info in serverData){
      allEpisodes.add(Episode.fromJson(info));
    }

    film.listEpisolds = allEpisodes;
    return film;
  }
}
