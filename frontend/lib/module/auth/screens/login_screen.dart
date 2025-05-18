import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/auth/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/storage_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'sign_up_screen.dart';
import 'profile_selection_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.email});

  final String? email;

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.email ?? '',
    ); // Pre-fill email if provided
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  void _handleLogin() async {
    if (isLoading) return; // Ngăn chặn nhiều lần nhấn nút
    setState(() {
      isLoading = true; // Đặt trạng thái đang tải
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = 'unknown';
    String deviceName = 'unknown';
    String deviceType =
        Platform.isAndroid
            ? 'Android'
            : Platform.isIOS
            ? 'iOS'
            : 'Other';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
      deviceName = iosInfo.name;
    }
    
    print("device info $deviceId $deviceName $deviceType");

    // Kiểm tra thông tin đầu vào
    if (email.isEmpty || password.isEmpty) {
      showErrorNotify(
        context,
        "Missing information",
        "Please enter both email and password.",
      );
      setState(() {
        isLoading = false; // Đặt trạng thái không còn tải
      });
      return;
    }

    print("$deviceId $deviceName $deviceType");

    if (password.length < 8) {
      showErrorNotify(
        context,
        "Password too short",
        "Password must be at least 8 characters long.",
      );
      setState(() {
        isLoading = false; // Đặt trạng thái không còn tải
      });
      return;
    }

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final loginResult = await authRepository.login(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
      );

      final accountId = loginResult['accountId'] as int;
      print('Login successful, accountId: $accountId');
      // Lưu vao StorageService
      StorageService().saveUserInfo(
        accountId,
      ); // Lưu accountId vào StorageService
      StorageService().saveFirstInstall(false);
      // Lấy danh sách profiles
      print('Fetching profiles for accountId: $accountId');
      // Điều hướng tới ProfileSelectionScreen
      final String? accessToken = await StorageService().getAccessToken();
      if (accessToken == null) {
        showErrorNotify(context, 'Error', 'Access token not found.');
        return;
      }
      final profiles = await ProfileRepository(
        ApiService(),
      ).fetchProfiles2(accountId, accessToken);
      print('Fetched profiles after add: $profiles');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfileSelectionScreen(
                profiles: profiles,
                accountId: accountId,
              ),
        ),
        (Route<dynamic> route) => false,
      );
      
    } catch (e) {
      _handleLoginError(e);
    } finally {
      setState(() {
        isLoading = false; // Đặt trạng thái không còn tải
      });
    }
  }

  // Hàm xử lý lỗi đăng nhập
  void _handleLoginError(dynamic e) {
    //print('Login error: $e');
    String errorMessage = 'An unknown error occurred';

    if (e is DioException) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');

        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('code')) {
            errorMessage = responseData['code'].toString();
          } else {
            errorMessage = 'An unknown error occurred';
          }
        } else if (responseData != null) {
          errorMessage = responseData.toString();
        }
      } else {
        errorMessage = e.message ?? 'An unknown Dio error occurred';
      }
    }
    if (errorMessage == '1008') {
      errorMessage = "Password is incorrect";
    }
    if (errorMessage == '1007') {
      errorMessage = 'This account is not activated. Please contact support.';
    }
    if (errorMessage == '1014') {
      errorMessage = ' Exceeds max device limit. Please contact support.';
    }
    showErrorNotify(context, "Login failed", errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Netflex"),
        backgroundColor: Colors.black,
        // màu chữ của appbar
        foregroundColor: Colors.red,

        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      Scaffold.of(context).appBarMaxHeight! -
                      MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (_) {
                        _emailFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      isPassword: true,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: isLoading ? "Signing In..." : "Sign In",
                      onPressed: isLoading ? () {} : _handleLogin,
                      backgroundColor: isLoading ? Colors.grey : Colors.red,
                      textColor: Colors.white,
                      fontSize: 18,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => print("Need help button pressed"),
                      child: Padding(
                        // Thêm padding để dễ nhấn và tạo khoảng cách
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "Need help?",
                          style: TextStyle(
                            color:
                                Colors.white, // Chữ trắng (hơi mờ để phân biệt)
                            fontSize: 18,
                            fontWeight: FontWeight.bold, // Chữ đậm
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "New to Netflex? ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        children: [
                          TextSpan(
                            text: "Sign up now",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      "Sign in is protected by Google reCAPTCHA to ensure you're not a bot. Learn more.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? MediaQuery.of(context).viewInsets.bottom + 20
                              : 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
