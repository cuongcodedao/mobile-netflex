import 'dart:convert'; // Import jsonEncode
import 'package:dio/dio.dart'; // Import Options từ thư viện dio
import 'package:frontend/models/token/token.dart';
import 'package:frontend/models/user_model.dart';

import 'dart:developer';
import 'package:frontend/models/auth.dart'; // đổi tên file thành auth.dart
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<Token> refreshToken(String refreshToken) async{
    try {
      final response = await apiService.post(
        '/api/v1/auth/refresh-token',
        {"refreshToken": refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final token = Token.fromJson(
        response.data['result'],
      );
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
  }) async {
    try {
      print('Sending login request with email: $email and password: $password');
      final response = await apiService.post(
        '/api/v1/auth/signin',
        {"email": email, "password": password},
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
      StorageService().saveTokens(token); // Luu accessToken va refreshToken

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
}
