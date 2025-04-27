import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/services/api_services.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final authRepositoryProvider = Provider((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthRepository(apiService);
});
