import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://83d0-117-2-255-206.ngrok-free.app'),
  );
  String? _accessToken; // Biến lưu trữ accessToken

  ApiService() {
    // Remove hardcoded accessToken initialization
  }

  void setAccessToken(String token) {
    _accessToken = token;
  }

  String? getAccessToken() {
    return _accessToken;
  }

  // Hàm GET
  Future<Response> get(String endpoint, {Map<String, dynamic>? data}) async {
    if (_accessToken != null)
      print("Co nhan Access Token ${_accessToken}");
    else
      print("Get khong nhan acccesToken");
    return await _dio.get(
      endpoint,
      options: Options(
        headers: {
          if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        },
      ),
    );
  }

  Future<Response> get1(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('POST request failed: ${e.message}');
    }
  }

  // Hàm POST
  Future<Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    Options? options,
  }) async {
    try {
      print('Request URL: ${_dio.options.baseUrl}$endpoint');
      print(
        'Request headers: ${options?.headers ?? {'Authorization': 'Bearer $_accessToken', 'Content-Type': 'application/json'}}',
      );
      print('Request body: $data');

      final response = await _dio.post(
        endpoint,
        data: jsonEncode(data), // ✨ ép thành JSON string
        options:
            options ??
            Options(
              headers: {
                if (_accessToken != null)
                  'Authorization': 'Bearer $_accessToken',
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
