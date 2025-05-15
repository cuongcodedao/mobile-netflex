import 'dart:ffi';
import 'package:frontend/module/account/screens/manager_account_screen.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/module/account/screens/manager_profile_screen.dart';
import 'package:frontend/module/history/screens/history_screen.dart';
import 'package:frontend/module/home/screens/my_list_page.dart';
import 'package:frontend/module/profile/widgets/button_icon.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/subscription/manage_subscription_screen.dart';

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
        title: const Text(
          "Profile & More",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar Selector
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  return CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                      "assets/images/avatar-${index + 1}.png",
                    ),
                    backgroundColor: Colors.grey[800],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            InkWell(
              onTap: () => _handleGotoManagerProfile(context),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.manage_accounts, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Manage Profile",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

            const Divider(height: 40, color: Colors.white24),

            // Settings buttons
            ButtonIcon(
              text: "Subscription",
              icon: Icons.notifications_none,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageSubscriptionScreen(),
                  ),
                );
              },
            ),
            ButtonIcon(
              text: "My List",
              icon: Icons.favorite_border,
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
              icon: Icons.settings_outlined,
              onTap: () {},
            ),
            ButtonIcon(
              text: "Account",
              icon: Icons.person_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManagerAccountScreen(),
                  ),
                );
              },
            ),
            ButtonIcon(
              text: "Help Center",
              icon: Icons.help_outline,
              onTap: () {},
            ),

            const SizedBox(height: 50),

            InkWell(
              onTap: () {
                // TODO: Add sign out logic
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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

