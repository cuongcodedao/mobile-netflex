import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://a6ea-2001-ee0-4c5d-f900-1c02-ce6d-315f-f62e.ngrok-free.app/',
    ),
  );

  // Hàm GET
  Future<Response> get(
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

  // ✅ Hàm POST
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw Exception('POST request failed: ${e.message}');
    }
  }
}
