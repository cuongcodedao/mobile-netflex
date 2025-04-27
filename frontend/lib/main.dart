import 'package:flutter/material.dart';
import 'package:frontend/module/auth/screens/onboarding_screen.dart';
import 'package:frontend/module/auth/screens/get_started_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/module/watching/screens/watching_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
