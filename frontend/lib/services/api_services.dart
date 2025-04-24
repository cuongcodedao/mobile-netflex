import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://ophim1.com/'),
  );

  // Hàm GET
  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
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
