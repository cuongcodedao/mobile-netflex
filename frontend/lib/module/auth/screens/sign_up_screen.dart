import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart'; // Điều chỉnh đường dẫn nếu cần
import '../widgets/custom_button.dart'; // Điều chỉnh đường dẫn nếu cần
import 'login_screen.dart'; // Import LoginScreen để điều hướng

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  void _handleSignUp() {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Xử lý đăng ký
    print('Email: $email, Phone: $phone, Password: $password');
    // Sau khi đăng ký thành công, có thể điều hướng đến màn hình chính hoặc login
    // Ví dụ: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up Successful (Simulated)')),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
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
        leading: IconButton( // Nút back
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset: true, // Cho phép thay đổi kích thước khi bàn phím hiện
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Ẩn bàn phím khi chạm ra ngoài
        child: SingleChildScrollView( // Cho phép cuộn nếu nội dung quá dài
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
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocusNode),
                backgroundColor: Colors.white, // Nền ô input trắng
                textColor: Colors.black, // Chữ nhập màu đen
                hintColor: Colors.grey, // Màu hint xám
                borderColor: Colors.green, // Viền xanh lá
                borderWidth: 1.0, // Độ dày viền
                borderRadius: 4.0, // Bo góc viền (tùy chỉnh)
              ),
              const SizedBox(height: 16),
              // Phone Number Input
              CustomTextField(
                controller: _phoneController,
                hintText: "Phone Number",
                focusNode: _phoneFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone, // Kiểu bàn phím số điện thoại
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
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
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
                      if (Navigator.canPop(context)) {
                         Navigator.pop(context);
                      } else {
                        // Trường hợp dự phòng: nếu không thể pop, thì pushReplacement
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }
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