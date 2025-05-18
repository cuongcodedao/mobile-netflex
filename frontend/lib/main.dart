import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/profile/profile_model.dart';
import 'package:frontend/models/token/token.dart';
import 'package:frontend/module/auth/screens/login_screen.dart';
import 'package:frontend/module/auth/screens/onboarding_screen.dart';
import 'package:frontend/module/home/screens/home_screen.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageService storageService = StorageService();
  bool? isFirstInstall = await storageService.getFirstInstall();
  bool isLogin = false;
  String? refreshToken = await storageService.getRefreshToken();
  int? profileID = await storageService.getProfileId();
  int? accountID = await storageService.getUserInfo();
  ProfileModel? profile;
  if(refreshToken != null){
    print("Co lay duoc refresh token");
  }
  if (refreshToken != null) {
    try {
      Token? token = await AuthRepository(
        ApiService(),
      ).refreshToken(refreshToken);

      if(token != null){
        print("co the lay lai duoc token");
      }
      else {
        print("khong co the lay lai duoc token");
      }
      if(accountID != null){
        print("co the lay duoc accountID");
      }
      else {
        print("khong co the lay duoc accountID");
      }

      if (token == null || accountID == null || profileID == null) {
        isLogin = false;
      } else {
        profile = await ProfileRepository(ApiService()).fetchProfile2(accountID, token.accessToken, profileID);
        isLogin = true;
        storageService.saveTokens(token);
      }
    } catch (e) {
      print("Loi khi lai refresh"+ e.toString());
      isLogin = false;
    }
  }

  runApp(
    ProviderScope(
      child: MyApp(
        isFirstInstall: isFirstInstall ?? true,
        isLogin: isLogin,
        profile: profile,
      ),
    ),
  ); // Thêm ProviderScope bao bọc ứng dụng
}

class MyApp extends StatelessWidget {
  final bool isFirstInstall;
  final bool isLogin;
  final ProfileModel? profile;
  const MyApp({
    super.key,
    required this.isFirstInstall,
    required this.isLogin,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          (isFirstInstall)
              ? OnboardingScreen()
              : (isLogin)
              ? HomeScreen(profile: profile!)
              : LoginScreen(),
    );
  }
}
