import 'dart:convert'; // Import jsonEncode
import 'package:dio/dio.dart'; // Import Options từ thư viện dioauthrep
import 'package:frontend/models/token/token.dart';
import 'package:frontend/models/auth/user_model.dart';

import 'dart:developer';
import 'package:frontend/models/auth/auth.dart'; // đổi tên file thành auth.dart
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class AuthRepository {
  final ApiService apiService;
  final StorageService storageService = StorageService();

  AuthRepository(this.apiService);

  Future<Token> refreshToken(String refreshToken) async {
    try {
      final response = await apiService.post(
        '/api/v1/auth/refresh-token',
        {"refreshToken": refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("refresh data " + response.data.toString());
      final token = Token.fromJson(response.data['result']);
      print("co lay duoc token " + token.toString());
      return token;
    } catch (e) {
      print('Refresh token error: $e');
      rethrow;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await apiService.get(
        '/api/v1/auth/check-email?email=$email',
      );
      final authResponse = Auth<bool>.fromJson(
        response.data,
        (json) => json as bool,
      );
      return authResponse.result;
    } catch (e) {
      print('Check email error: $e');
      rethrow;
    }
  }

  Future<UserModel> registerAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      final response = await apiService.post('/api/v1/auth/signup', {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      });
      final authResponse = Auth<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
      return authResponse.result;
    } catch (e) {
      print('Register account error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String deviceId,
    required String deviceName,
    required String deviceType,
  }) async {
    try {
      print('Sending login request with email: $email and password: $password');
      final response = await apiService.post(
        '/api/v1/auth/signin',
        {
          "email": email,
          "password": password,
          "deviceId": deviceId,
          "deviceName": deviceName,
          "deviceType": deviceType,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      //print('Request headers: ${response.requestOptions.headers}');
      //print('Request body: ${response.requestOptions.data}');
      final data = response.data['result'];
      Token token = Token.fromJson(data);
      if (data == null ||
          data['account'] == null ||
          data['account']['id'] == null) {
        throw Exception('Invalid response: Missing account or account ID');
      }

      final user = UserModel.fromJson(data['account']);
      final accountId =
          data['account']['id'] as int; // Đảm bảo accountId không phải null
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      print("Access token: ${token.accessToken}");
      StorageService().saveTokens(token);
      // Luu accessToken va refreshToken

      // Set the accessToken in ApiService after successful login
      apiService.setAccessToken(accessToken);

      return {
        'user': user,
        'accountId': accountId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Hàm lấy thông tin người dùng bằng accountId
  Future<UserModel> getUserInfo(int accountId) async {
    try {
      String? accessToken = await StorageService().getAccessToken();
      final response = await apiService.get1('/api/v1/account/$accountId', 
          token: accessToken);
      final authResponse = Auth<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );
      return authResponse.result;
    } catch (e) {
      print('Get user info error: $e');
      rethrow;
    }
  }

  // Hàm cập nhật thông tin như firstName, lastName và mật khẩu
  Future<Map<String, dynamic>> updateUserInfo({
    required int id,
    String? firstName,
    String? lastName,
    String? password,
  }) async {
    try {
      final response = await apiService.put('/api/v1/account/$id', {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      });

      // Trả về nguyên bản response data từ server
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Update user info error: $e');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> updateUserInfo2({
  required int id,
  String? firstName,
  String? lastName,
  String? password,
  String? accessToken, // Thêm access token làm tham số tùy chọn
}) async {
  try {
    final response = await apiService.put1(
      '/api/v1/account/$id',
      {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      },
      token: accessToken, // Sử dụng access token nếu có
    );

    // Trả về nguyên bản response data từ server
    return response.data as Map<String, dynamic>;
  } catch (e) {
    print('Update user info error: $e');
    rethrow;
  }
}


  // Hàm xóa tài khoản
  Future<Map<String, dynamic>> deleteAccount(int id) async {
    try {
      final response = await apiService.delete('/api/v1/account/$id');
      // Trả về nguyên bản response data từ server
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Update user info error: $e');
      rethrow;
    }
  }
}
