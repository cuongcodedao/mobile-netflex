
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/models/film/category.dart';

class CategoryRepository {
  final ApiService apiService;

  CategoryRepository(this.apiService);

  

  Future<List<Category>> getAllCategory() async {
    try {
      String? accessToken = await StorageService().getAccessToken();
      final response = await apiService.get1(
        '/api/v1/category',
      // token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjdW9uZ2RhbmdAZ21haWwuY29tIiwiaWF0IjoxNzQ2NDE4NTAwLCJleHAiOjE3NDY1MDQ5MDB9.CuFycmZcaXTohc2OFtNLDPQMqOHG8CztbbVf6cd9G8o",
        token: accessToken
      );
      final List<dynamic> results = response.data['result'] ?? [];
      List<Category> categories = [];
      for (int i = 0; i < results.length; ++i) {
        categories.add(Category.fromJson(results[i]));
      }

      return categories;
    } catch (e) {
      return [];
    }
  }
}
