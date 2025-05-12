import 'package:dio/dio.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/my_list/my_list_film.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class MyListRepository {
  final ApiService apiService;

  MyListRepository(this.apiService);

  Future<bool> addMyListFilm(String slug) async {
    String? accessToken = await StorageService().getAccessToken();
    int? profileId = await StorageService().getProfileId();

    if (profileId == null || accessToken == null) return false;

    try {
      final response = await apiService.post(
        '/api/v1/mylist',
        {"profileId": profileId, "slugMovie": slug},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return true;
    } catch (e) {
      print('add my list film error: ${slug} $e');
      return false;
    }
  }

  Future<bool> removeMyListFilm(String slug) async {
    String? accessToken = await StorageService().getAccessToken();
    int? profileId = await StorageService().getProfileId();

    if (profileId == null || accessToken == null) return false;

    try {
      final response = await apiService.post(
        '/api/v1/favorite',
        {"categorySlug": slug, "profileId": profileId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return true;
    } catch (e) {
      print('add my list false: $e');
      return false;
    }
  }

  Future<List<Film>> getMyListFilm() async {
    String? accessToken = await StorageService().getAccessToken();
    int? profileId = await StorageService().getProfileId();
    try {
      final response = await apiService.get1(
        '/api/v1/mylist/profile/${profileId}',
        token: accessToken,
      );

      print("search: " + response.data['result'].toString());

      final List<dynamic> data = response.data['result'] ?? [];
      final List<Film> results =
          data.map((item) => Film.fromJson(item)).toList();

      return results;
    } catch (e) {
      print("Error my list film repository: $e");
      return [];
    }
  }
}
