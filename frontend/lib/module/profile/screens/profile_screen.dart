import 'package:flutter/material.dart';
import 'package:frontend/module/history/screens/history_screen.dart';
import 'package:frontend/module/home/screens/my_list_page.dart';
import 'package:frontend/module/profile/widgets/button_icon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              onTap: () {},
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
              text: "Notifications",
              icon: Icons.notifications_none,
              onTap: () {},
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
              onTap: () {},
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
}
