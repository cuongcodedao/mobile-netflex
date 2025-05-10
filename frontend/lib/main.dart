import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/auth/screens/onboarding_screen.dart';
import 'package:frontend/module/auth/screens/get_started_screen.dart';
import 'package:frontend/module/history/screens/history_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/home/screens/my_list_page.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // Thêm ProviderScope bao bọc ứng dụng
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HistoryScreen(),
    );
  }
}
