import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart'; // Import ProfileModel
import 'package:frontend/module/auth/screens/add_profile_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/services/storage_service.dart';

class Profile {
  final String name;
  final Color color;

  const Profile({required this.name, required this.color});
}

class ProfileSelectionScreen extends StatelessWidget {
  static const routeName = '/profile-selection';

  final List<ProfileModel> profiles; // Accept profiles as a parameter
  final int accountId; // Thêm accountId làm tham số

  const ProfileSelectionScreen({super.key, required this.profiles, required this.accountId});

  static const String avatarPngPath = 'assets/images/avatar.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Ai đang xem?',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  itemCount: profiles.length + 1, // Thêm 1 để hiển thị nút "Thêm profile"
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    if (index < profiles.length) {
                      final profile = profiles[index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _goToHomeScreen(context, profile),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0), // Bo góc cho avatar
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Image.asset(
                                    'assets/images/${profile.avatar}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[700],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.white54,
                                            size: 40,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            profile.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    } else {
                      // Nút "Thêm profile"
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProfileScreen(accountId: accountId), // Truyền accountId
                            ),
                          ).then((newProfile) {
                            if (newProfile != null) {
                              print('New profile added: ${newProfile.username}');
                            }
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Image.asset(
                                'assets/images/avatar.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Thêm profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _goToHomeScreen(BuildContext context, ProfileModel profile) {
    StorageService().saveProfileId(profile.id!);
    print("Id Profile :" + profile.id!.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
      (context) => HomeScreen(),
      ),
    );
  }
}
