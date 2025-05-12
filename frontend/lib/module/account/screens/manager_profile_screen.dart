import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/module/auth/screens/add_profile_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/notify/screens/warning-notify.dart';
import 'package:frontend/services/storage_service.dart';

class ManagerProfileScreen extends ConsumerWidget {
  final List<ProfileModel> profiles;
  final int accountId;

  const ManagerProfileScreen({
    super.key,
    required this.profiles,
    required this.accountId,
  });
 
  static const String avatarPngPath = 'assets/images/avatar.png';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Quản lý Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: profiles.length + 1,
        itemBuilder: (context, index) {
          if (index < profiles.length) {
            final profile = profiles[index];
            return GestureDetector(
              onTap: () => _handleProfileTap(context, profile),
              child: Card(
                color: Colors.grey[800],
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Avatar with border indicator for current profile
                      FutureBuilder<int?>(
                        future: StorageService().getProfileId(),
                        builder: (context, snapshot) {
                          final isCurrentProfile = snapshot.data == profile.id;
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: isCurrentProfile 
                                ? Border.all(color: Colors.green, width: 2)
                                : null,
                              image: DecorationImage(
                                image: AssetImage('assets/images/${profile.avatar}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.username,
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FutureBuilder<int?>(
                              future: StorageService().getProfileId(),
                              builder: (context, snapshot) {
                                if (snapshot.data == profile.id) {
                                  return Text(
                                    'Đang sử dụng',
                                    style: TextStyle(
                                      color: Colors.green[400],
                                      fontSize: 14,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDeleteTap(context, ref, profile),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _handleAddProfile(context),
              child: Card(
                color: Colors.grey[800],
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[600],
                          image: const DecorationImage(
                            image: AssetImage(avatarPngPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Thêm profile',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _handleAddProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProfileScreen(accountId: accountId),
      ),
    );
  }
  

  Future<void> _handleDeleteTap(BuildContext context, WidgetRef ref, ProfileModel profile) async {
    if (profiles.length <= 1) {
      showErrorNotify(context, 'Lỗi', 'Không thể xóa profile. Vui lòng thêm profile khác.');
      return;
    }
    
    // Check if trying to delete current profile
    final currentProfileId = await StorageService().getProfileId();
    if (currentProfileId == profile.id) {
      showErrorNotify(context, 'Lỗi', 'Không thể xóa profile đang sử dụng. Vui lòng chuyển sang profile khác trước.');
      return;
    }

    bool? result = await showWarningNotify(
      context,
      'Cảnh báo',
      'Bạn có muốn xóa profile ${profile.username} không?',
    );

    if (result == false) {
      return;
    }

    try {
      final profileRepository = ref.read(profileRepositoryProvider);
      bool deleteSuccess = await profileRepository.deleteProfile(profile.id!);

      if (deleteSuccess) {
        profiles.removeWhere((p) => p.id == profile.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManagerProfileScreen(
              profiles: profiles,
              accountId: accountId,
            ),
          ),
        );
        showSuccessNotify(context, 'Thành công', 'Đã xóa profile ${profile.username}.');
      } else {
        showErrorNotify(context, 'Lỗi', 'Không thể xóa profile. Vui lòng thử lại sau.');
      }
    } catch (e) {
      showErrorNotify(context, 'Lỗi', 'Không thể xóa profile. Vui lòng thử lại sau.');
    }
  }

  Future<void> _handleProfileTap(BuildContext context, ProfileModel profile) async {
    int? currentID = await StorageService().getProfileId();
    if (currentID == profile.id) {
      showErrorNotify(context, 'Thông báo', 'Bạn đang sử dụng profile này.');
      return;
    }

    bool? result = await showWarningNotify(
      context,
      'Thông báo',
      'Bạn có muốn chuyển sang profile ${profile.username} không?',
    );
    if (result == true){
      await StorageService().saveProfileId(profile.id!);
      showSuccessNotify(context, 'Thành công', 'Đã chuyển sang profile ${profile.username}.');
       _goToHomeScreen(context, profile);
    } else {
      return;
    }
  }

  void _goToHomeScreen(BuildContext context, ProfileModel profile) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(profile: profile),
      ),
      (route) => false,
    );
  }
}