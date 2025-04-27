import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://7ad7-2001-ee1-f404-c0d0-6018-46d-5b5-44e4.ngrok-free.app'),
  );

  String? _accessToken; // Biến lưu trữ accessToken

  ApiService() {
    // Set cố định accessToken
    setAccessToken("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmcxMTMwNUBnbWFpbC5jb20iLCJpYXQiOjE3NDU2NzUzNTcsImV4cCI6MTc0NTc2MTc1N30.dqViLvco-sdgNn7ecFwa56PcCPr0WoX-6ZxFgzPPpuw");
  }

  void setAccessToken(String token) {
    _accessToken = token;
  }

  // Hàm GET
  Future<Response> get(String endpoint) async {
    return await _dio.get(
      endpoint,
      options: Options(
        headers: {
          if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        },
      ),
    );
  }

  // Hàm POST
Future<Response> post(String endpoint, Map<String, dynamic> data, {Options? options}) async {
  try {
    print('Request URL: ${_dio.options.baseUrl}$endpoint');
    print('Request headers: ${options?.headers ?? {'Authorization': 'Bearer $_accessToken', 'Content-Type': 'application/json'}}');
    print('Request body: $data');

    final response = await _dio.post(
      endpoint,
      data: jsonEncode(data), // ✨ ép thành JSON string
      options: options ??
          Options(
            headers: {
              if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
              'Content-Type': 'application/json', // ✨ thêm content type
            },
          ),
    );

    print('Response status code: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response;
  } on DioException catch (e) {
    throw Exception('POST request failed: ${e.message}');
  }
}
}