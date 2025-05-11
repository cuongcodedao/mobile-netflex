import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/auth/user_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/services/storage_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'sign_up_screen.dart';
import 'profile_selection_screen.dart';

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

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Kiểm tra thông tin đầu vào
    if (email.isEmpty || password.isEmpty) {
      showErrorNotify(
        context,
        'Thiếu thông tin',
        'Vui lòng nhập email và mật khẩu.',
      );
      return;
    }

    if (password.length < 8) {
      showErrorNotify(
        context,
        'Mật khẩu không hợp lệ',
        'Mật khẩu phải có ít nhất 8 ký tự.',
      );
      return;
    }

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final loginResult = await authRepository.login(
        email: email,
        password: password,
      );

      final accountId = loginResult['accountId'] as int;
      print('Login successful, accountId: $accountId');
      // Lưu vao StorageService
      StorageService().saveUserInfo(accountId); // Lưu accountId vào StorageService

      // Lấy danh sách profiles
      print('Fetching profiles for accountId: $accountId');
      final profiles = await ref.read(profileProvider(accountId).future);
      print('Fetched profiles: $profiles');

      // Điều hướng tới ProfileSelectionScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfileSelectionScreen(
                profiles: profiles,
                accountId: accountId,
              ),
        ),
      );
    } catch (e) {
      _handleLoginError(e);
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
      errorMessage = 'Sai mật khẩu, vui lòng thử lại';
    }
    showErrorNotify(context, 'Đăng nhập thất bại', errorMessage);
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
                      text: "Sign In",
                      onPressed: _handleLogin,
                      backgroundColor: Colors.red,
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
                    CustomButton(
                      text: "New to Netflex? Sign up now",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      fontSize: 20,
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
