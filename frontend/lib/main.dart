import 'package:flutter/material.dart';
import 'package:frontend/module/auth/screens/login_screen.dart';
import 'package:frontend/module/auth/screens/sign_up_screen.dart';
import 'package:frontend/module/auth/screens/profile_selection_screen.dart';
import 'package:frontend/module/auth/screens/add_profile_screen.dart';
import 'package:frontend/module/auth/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Film App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Màu nền của ứng dụng
      ),
      home: const HomeScreen(), // Sử dụng HomeScreen làm màn hình chính
      // debugShowCheckedModeBanner: false,
      // initialRoute: LoginScreen.routeName,
      // routes: {
      //   LoginScreen.routeName: (context) => const LoginScreen(),
      //   SignUpScreen.routeName: (context) => const SignUpScreen(),
      //   ProfileSelectionScreen.routeName: (context) => const ProfileSelectionScreen(),
      //   AddProfileScreen.routeName: (context) => const AddProfileScreen(),
      // },
    );
  }
}