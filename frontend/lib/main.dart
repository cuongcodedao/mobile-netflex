import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/film/film.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/module/auth/screens/onboarding_screen.dart';
import 'package:frontend/module/auth/screens/get_started_screen.dart';
import 'package:frontend/module/auth/screens/profile_selection_screen.dart';
import 'package:frontend/module/history/screens/history_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/home/screens/my_list_page.dart';
import 'package:frontend/module/home/screens/search_page.dart';
import 'package:frontend/module/profile/screens/profile_screen.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  ); // Thêm ProviderScope bao bọc ứng dụng
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
