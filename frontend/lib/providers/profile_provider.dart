import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/storage_service.dart'; // Import apiServiceProvider từ auth_provider

final profileProvider = FutureProvider.family<List<ProfileModel>, int>((
  ref,
  accountId,
) async {
  final profileRepository = ref.read(profileRepositoryProvider);
  try {
    print(
      'Fetching profiles for accountId: $accountId',
    ); // Log trước khi gọi API
    final profiles = await profileRepository.fetchProfiles(accountId);
    print(
      'Profiles fetched successfully: $profiles',
    ); // Log sau khi lấy danh sách profile
    return profiles;
  } catch (e) {
    print('Error fetching profiles: $e'); // Log lỗi nếu xảy ra
    rethrow;
  }
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProfileRepository(apiService);
});
