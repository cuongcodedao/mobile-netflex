import 'package:flutter/material.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/services/api_services.dart';
import '../widgets/custom_textfield.dart'; // Điều chỉnh đường dẫn nếu cần
import '../widgets/custom_button.dart'; // Điều chỉnh đường dẫn nếu cần
import 'login_screen.dart'; // Import LoginScreen để điều hướng
import 'package:dio/dio.dart';

class SignUpScreen extends StatefulWidget {
  final String? email; // Optional email parameter

  const SignUpScreen({super.key, this.email});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email ?? ''); // Pre-fill email if provided
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      showErrorNotify(context, 'Thiếu thông tin', 'Vui lòng nhập đầy đủ thông tin.');
      return;
    }

    if (password != confirmPassword) {
      showErrorNotify(context, 'Mật khẩu không khớp', 'Vui lòng nhập lại mật khẩu.');
      return;
    }
    
    try {
      final authRepository = AuthRepository(ApiService());
      final user = await authRepository.registerAccount(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Successful! Welcome, ${user.firstName}')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(email: email)),
      );
    } catch (e) {
      _handleSignupError(e);
    }
  }
// Hàm xử lý lỗi đăng nhập
void _handleSignupError(dynamic e) {
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
  if (errorMessage == '1001') {
    errorMessage = 'Email đã tồn tại';
  }
  if (errorMessage == '9999') {
    errorMessage = 'Mật khẩu phải có ít nhất 8 ký tự';
  }
  showErrorNotify(
    context,
    'Đăng ký thất bại',
    errorMessage,
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.white, // Nền AppBar trắng
        foregroundColor: Colors.black, // Màu chữ/icon AppBar đen
        elevation: 0, // Bỏ bóng dưới AppBar
        leading: IconButton(
          // Nút back
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Cho phép thay đổi kích thước khi bàn phím hiện
      body: GestureDetector(
        onTap:
            () =>
                FocusScope.of(
                  context,
                ).unfocus(), // Ẩn bàn phím khi chạm ra ngoài
        child: SingleChildScrollView(
          // Cho phép cuộn nếu nội dung quá dài
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Email Input
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress, // Kiểu bàn phím email
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_firstNameFocusNode),
                backgroundColor: Colors.white, // Nền ô input trắng
                textColor: Colors.black, // Chữ nhập màu đen
                hintColor: Colors.grey, // Màu hint xám
                borderColor: Colors.green, // Viền xanh lá
                borderWidth: 1.0, // Độ dày viền
                borderRadius: 4.0, // Bo góc viền (tùy chỉnh)
              ),
              const SizedBox(height: 16),
              // First Name Input
              CustomTextField(
                controller: _firstNameController,
                hintText: "First Name",
                focusNode: _firstNameFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_lastNameFocusNode),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.grey,
                borderColor: Colors.green,
                borderWidth: 1.0,
                borderRadius: 4.0,
              ),
              const SizedBox(height: 16),
              // Last Name Input
              CustomTextField(
                controller: _lastNameController,
                hintText: "Last Name",
                focusNode: _lastNameFocusNode,
                keyboardType: TextInputType.name,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.grey,
                borderColor: Colors.green,
                borderWidth: 1.0,
                borderRadius: 4.0,
              ),
              const SizedBox(height: 16),
              // Password Input
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isPassword: true,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.next,
                onSubmitted:
                    (_) => FocusScope.of(
                      context,
                    ).requestFocus(_confirmPasswordFocusNode),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.grey,
                borderColor: Colors.green,
                borderWidth: 1.0,
                borderRadius: 4.0,
              ),
              const SizedBox(height: 16),
              // Confirm Password Input
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: "Password Again",
                isPassword: true,
                focusNode: _confirmPasswordFocusNode,
                textInputAction: TextInputAction.done, // Action cuối cùng
                onSubmitted: (_) => _handleSignUp(), // Gửi form khi nhấn done
                backgroundColor: Colors.white,
                textColor: Colors.black,
                hintColor: Colors.grey,
                borderColor: Colors.green,
                borderWidth: 1.0,
                borderRadius: 4.0,
              ),
              const SizedBox(height: 30),
              // Sign Up Button
              CustomButton(
                text: "Sign Up",
                onPressed: _handleSignUp,
                backgroundColor: Colors.red, // Nút màu đỏ
                textColor: Colors.white, // Chữ nút màu trắng
                fontSize: 18,
                padding: const EdgeInsets.symmetric(vertical: 16),
                borderRadius: 4.0,
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
                      color: Colors.black, // Chữ trắng (hơi mờ để phân biệt)
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Chữ đậm
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Link to Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Quay lại màn hình Login
                      // Navigator.pop(context) hoạt động tốt nếu SignUp được push từ Login
                      
                        // Trường hợp dự phòng: nếu không thể pop, thì pushReplacement
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen(email: "")),
                        );
                      
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.red, // Màu đỏ cho link
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Gạch chân
                        decorationColor: Colors.red, // Màu gạch chân
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Thêm khoảng trống dưới cùng
            ],
          ),
        ),
      ),
    );
  }
}

