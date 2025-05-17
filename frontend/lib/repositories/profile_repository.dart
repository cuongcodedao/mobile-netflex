import 'package:dio/dio.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/auth/auth.dart';
import 'package:frontend/models/film/category.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository(this.apiService);

  Future<List<ProfileModel>> fetchProfiles(int accountId) async {
    try {
      //print('Fetching profiles for accountId: $accountId'); // Log trước khi gọi API
      final response = await apiService.get(
        '/api/v1/profile/account/$accountId',
      );
      //print('API response: ${response.data}'); // Log phản hồi từ API
      final authResponse = Auth<List<ProfileModel>>.fromJson(
        response.data,
        (json) =>
            (json as List<dynamic>?)
                ?.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
      //print('Mapped profiles: ${authResponse.result}'); // Log sau khi ánh xạ dữ liệu
      return authResponse.result;
    } catch (e) {
      print('Error in fetchProfiles: $e'); // Log lỗi nếu xảy ra
      rethrow;
    }
  }

  Future<List<ProfileModel>> fetchProfiles2(
    int accountId,
    String accessToken,
  ) async {
    try {
      final response = await apiService.get1(
        '/api/v1/profile/account/$accountId',
        token: accessToken,
      );

      final profiles = Auth<List<ProfileModel>>.fromJson(
        response.data,
        (json) =>
            (json as List<dynamic>?)
                ?.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

      return profiles.result;
    } catch (e) {
      print('Error in fetchProfiles: $e');
      rethrow;
    }
  }

  Future<ProfileModel> fetchProfile2(
    int accountId,
    String accessToken,
    int profileID,
  ) async {
    try {
      final response = await apiService.get1(
        '/api/v1/profile/account/$accountId',
        token: accessToken,
      );

      final profiles = Auth<List<ProfileModel>>.fromJson(
        response.data,
        (json) =>
            (json as List<dynamic>?)
                ?.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

      final profile = profiles.result.firstWhere(
        (profile) => profile.id == profileID,
      );
      return profile;
    } catch (e) {
      print('Error in fetchProfiles: $e');
      rethrow;
    }
  }

  Future<ProfileModel> fetchProfile(int profileId) async {
    try {
      final response = await apiService.get('/api/v1/profile/$profileId');
      final authResponse = Auth<ProfileModel>.fromJson(
        response.data,
        (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
      );
      return authResponse.result;
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<ProfileModel> addProfile({
    required String username,
    required String avatar,
    required bool kid,
    required int accountId,
    List<Category>? favoriteGenres,
  }) async {
    try {
      final response = await apiService.post('/api/v1/profile', {
        "username": username,
        "avatar": avatar,
        "kid": kid,
        "account_id": accountId,
        "favorite_genres": favoriteGenres?.map((genre) => genre.slug).toList(),
      });
      print('Add profile response: ${response.data}');
      return ProfileModel.fromJson(response.data['result']);
    } catch (e) {
      print('Error adding profile: $e');
      rethrow;
    }
  }

  Future<bool> deleteProfile(int profileId) async {
    try {
      final response = await apiService.delete('/api/v1/profile/$profileId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error deleting profile: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }
}
