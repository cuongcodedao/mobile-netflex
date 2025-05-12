import 'dart:ffi';
import 'package:frontend/module/account/screens/manager_account_screen.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/module/account/screens/manager_profile_screen.dart';
import 'package:frontend/module/history/screens/history_screen.dart';
import 'package:frontend/module/home/screens/my_list_page.dart';
import 'package:frontend/module/profile/widgets/button_avata.dart';
import 'package:frontend/module/profile/widgets/button_icon.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Profile & More", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 30),
                  itemBuilder: (context, index) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/avatar-1.png"),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: GestureDetector(
                  onTap: () {
                    _handleGotoManagerProfile(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending, color: Colors.white),
                      Text(
                        "Manager Profile",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonIcon(
                text: "Notification",
                icon: Icons.notifications,
                onTap: () {},
              ),
              ButtonIcon(
                text: "My list",
                icon: Icons.list,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyListPage()),
                  );
                },
              ),
              ButtonIcon(
                text: "History",
                icon: Icons.history,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
              ),
              ButtonIcon(
                text: "App Settings",
                icon: Icons.settings,
                onTap: () {},
              ),
              ButtonIcon(text: "Account", icon: Icons.person, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManagerAccountScreen()),
                );
              }),
              ButtonIcon(text: "Help", icon: Icons.help, onTap: () {}),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: InkWell(
                  child: Text(
                    "Sign out",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGotoManagerProfile(BuildContext context) async {
    try {
      StorageService storageService = StorageService();
      int? accountId = await storageService.getUserInfo();
      if (accountId == null) {
        print('Account ID không tồn tại');
        return;
      }

      final profiles = await ref.read(profileProvider(accountId).future);
      print('Fetched profiles: $profiles');

      // Chuyển sang màn hình ManagerProfileScreen nếu cần
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerProfileScreen(
            accountId: accountId,
            profiles: profiles,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }
}

