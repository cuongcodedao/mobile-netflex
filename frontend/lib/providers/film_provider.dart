import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/film_repository.dart';
import 'package:frontend/services/api_services.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final filmRepositoryProvider = Provider((ref) {
  final apiService = ref.read(apiServiceProvider);
  return FilmRepository(apiService);
});
