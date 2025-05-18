import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://54.255.180.117:8080'),
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
        data: data, // Để Dio tự chuyển Map thành JSON
        options:
            options ??
            Options(
              headers: {
                if (_accessToken != null)
                  'Authorization': 'Bearer $_accessToken',
                'Content-Type': 'application/json',
              },
            ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      // Ném lại DioException để xử lý ở phần gọi hàm
      throw e;
    }
  }

  // Hàm DELETE
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      print('Request URL: ${_dio.options.baseUrl}$endpoint');
      print(
        'Request headers: ${token != null ? {'Authorization': 'Bearer $token'} : {'Authorization': 'Bearer $_accessToken'}}',
      );
      print('Request body: $data');

      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(
          headers: {
            if (token != null)
              'Authorization': 'Bearer $token'
            else if (_accessToken != null)
              'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('DELETE request failed: ${e.message}');
      throw Exception('DELETE request failed: ${e.message}');
    }
  }

  // Hàm PUT
  Future<Response> put(
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

      final response = await _dio.put(
        endpoint,
        data: data,
        options:
            options ??
            Options(
              headers: {
                if (_accessToken != null)
                  'Authorization': 'Bearer $_accessToken',
                'Content-Type': 'application/json',
              },
            ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      // Ném lại DioException để xử lý ở phần gọi hàm
      throw e;
    }
  }
}
