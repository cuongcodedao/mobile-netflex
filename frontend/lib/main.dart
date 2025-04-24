import 'package:flutter/material.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/profile/screens/profile_screen.dart';
import 'package:frontend/module/watching/screens/playing_film_page.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WatchingScreen(),
    );
  }
}
