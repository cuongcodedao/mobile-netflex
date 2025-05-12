import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/module/notify/screens/success-notify.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/module/auth/screens/add_profile_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/notify/screens/warning-notify.dart';


// Đảm bảo màn hình của bạn là ConsumerWidget hoặc sử dụng Consumer để đọc Provider
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
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/${profile.avatar}'),
                backgroundColor: Colors.grey,
              ),
              title: Text(
                profile.username,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _handleDeleteTap(context, ref, profile),
              ),
              onTap: () => _handleProfileTap(context, profile),
            );
          } else {
            return ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(avatarPngPath),
                backgroundColor: Colors.grey,
              ),
              title: const Text(
                'Thêm profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () => _handleAddProfile(context),
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
  // kiểm tra không cho xóa neetus chỉ còn lại 1 profile
  if (profiles.length <= 1) {
    showErrorNotify(context, 'Lỗi', 'Không thể xóa profile. Vui lòng thêm profile khác.');
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
      
      
     // Cập nhật danh sách profile
     profiles.removeWhere((p) => p.id == profile.id);
      // Load lại trang
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerProfileScreen(
            profiles: profiles, // Load lại danh sách profile mới
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
    bool? result = await showWarningNotify(
      context,
      'Thông báo',
      'Bạn có muốn chuyển sang profile ${profile.username} không?',
    );
    if (result == true) _goToHomeScreen(context, profile);
  }

  void _goToHomeScreen(BuildContext context, ProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(profile: profile),
      ),
    );
  }
}
