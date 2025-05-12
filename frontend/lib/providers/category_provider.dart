import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/category_repository.dart';
import 'package:frontend/services/api_services.dart';

final categoryApiServiceProvider = Provider((ref) => ApiService());

final categoryRepositoryProvider = Provider((ref) {
  final apiService = ref.read(categoryApiServiceProvider);
  return CategoryRepository(apiService);
});
