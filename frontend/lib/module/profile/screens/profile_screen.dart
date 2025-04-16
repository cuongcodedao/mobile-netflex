import 'package:flutter/material.dart';
import 'package:frontend/module/profile/widgets/button_avata.dart';
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
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Text("Profile & More", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    return ButtonAvata();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending, color: Colors.white),
                      Text(
                        "Manager Profile",
                        style: TextStyle(fontSize: 20, color: Colors.white),
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
              ButtonIcon(text: "My list", icon: Icons.list, onTap: () {}),
              ButtonIcon(
                text: "App Settings",
                icon: Icons.settings,
                onTap: () {},
              ),
              ButtonIcon(text: "Account", icon: Icons.person, onTap: () {}),
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
}
