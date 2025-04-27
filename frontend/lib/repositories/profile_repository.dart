import 'package:frontend/models/profile_model.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/models/auth.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository(this.apiService);

  Future<List<ProfileModel>> fetchProfiles(int accountId) async {
    try {
      //print('Fetching profiles for accountId: $accountId'); // Log trước khi gọi API
      final response = await apiService.get('/api/v1/profile/account/$accountId');
      //print('API response: ${response.data}'); // Log phản hồi từ API
      final authResponse = Auth<List<ProfileModel>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>?)?.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );
      //print('Mapped profiles: ${authResponse.result}'); // Log sau khi ánh xạ dữ liệu
      return authResponse.result;
    } catch (e) {
      print('Error in fetchProfiles: $e'); // Log lỗi nếu xảy ra
      rethrow;
    }
  }

  Future<ProfileModel> addProfile({
    required String username,
    required String avatar,
    required bool kid,
    required int accountId,
  }) async {
    try {
      final response = await apiService.post(
        '/api/v1/profile',
        {
          "username": username,
          "avatar": avatar,
          "kid": kid,
          "account_id": accountId,
        },
      );
      print('Add profile response: ${response.data}');
      return ProfileModel.fromJson(response.data['result']);
    } catch (e) {
      print('Error adding profile: $e');
      rethrow;
    }
  }
}