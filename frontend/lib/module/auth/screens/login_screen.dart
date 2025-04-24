import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'sign_up_screen.dart';
import 'profile_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Xử lý đăng nhập
    print('Email: $email, Password: $password');

    // test nếu pass và name là 123 thì chuyển sang màn hinh ProfileSelectionScreen
    if (email == "123" && password == "123") {
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => const ProfileSelectionScreen(),
      );
      Navigator.push(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
                        Navigator.pushNamed(context, SignUpScreen.routeName);
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
