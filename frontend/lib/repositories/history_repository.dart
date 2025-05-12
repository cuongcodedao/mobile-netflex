import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/models/history/film_history.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class HistoryRepository {
  final ApiService apiService;

  HistoryRepository(this.apiService);

  Future<bool> addFilmHistory(
    String slug,
    int episode,
    bool isFinish,
    int watchingDuration,
  ) async {
    String? accessToken = await StorageService().getAccessToken();
    int? profileId = await StorageService().getProfileId();

    if (profileId == null || accessToken == null) return false;
    print("Sending history body: ${jsonEncode(
      {
        "episodeIndex": episode,
        "finished": isFinish,
        "movie_slug": slug,
        "watch_duration": watchingDuration, // giây hoặc mili giây tùy backend
        "profile_id": profileId,
        "last_watch": DateTime.now().toUtc().toIso8601String(),
      },
    )}");

    try {
      final response = await apiService.post(
        '/api/v1/history',
      {
        "episodeIndex": episode,
        "finished": isFinish,
        "movie_slug": slug,
        "watch_duration": watchingDuration, // giây hoặc mili giây tùy backend
        "profile_id": profileId,
        "last_watch": DateTime.now().toUtc().toIso8601String(),
      },
        options: Options(
          headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('API error: ${response.statusCode} - ${response.data}');
        return false;
      }
    } catch (e) {
      print('add history error: $e');
      return false;
    }
  }

  Future<List<FilmHistory>> getFilmHistory() async {
    String? accessToken = await StorageService().getAccessToken();
    int? profileId = await StorageService().getProfileId();
    try {
      final response = await apiService.get1(
        '/api/v1/history/profile/${profileId}',
        token: accessToken,
      );

      print("search: " + response.data['result'].toString());

      final List<dynamic> data = response.data['result'] ?? [];
      final List<FilmHistory> results =
          data.map((item) => FilmHistory.fromJson(item)).toList();

      return results;
    } catch (e) {
      print("Error history repository: $e");
      return [];
    }
  }
}
