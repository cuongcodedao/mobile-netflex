import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/storage_service.dart'; // Import apiServiceProvider từ auth_provider

// Provider để lấy danh sách Profile dựa trên accountId
final profileProvider = FutureProvider.family<List<ProfileModel>, int>((ref, accountId) async {
  final profileRepository = ref.read(profileRepositoryProvider);
  try {
    print('Fetching profiles for accountId: $accountId');
    final profiles = await profileRepository.fetchProfiles(accountId);
    print('Profiles fetched successfully: $profiles');
    return profiles;
  } catch (e) {
    print('Error fetching profiles: $e');
    rethrow;
  }
});

// Provider để lấy chi tiết một Profile dựa trên profileId
final profileDetailProvider = FutureProvider.family<ProfileModel, int>((ref, profileId) async {
  final profileRepository = ref.read(profileRepositoryProvider);
  try {
    print('Fetching profile for profileId: $profileId');
    final profile = await profileRepository.fetchProfile(profileId);
    print('Profile fetched successfully: $profile');
    return profile;
  } catch (e) {
    print('Error fetching profile: $e');
    rethrow;
  }
});

// Provider cho ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProfileRepository(apiService);
});
