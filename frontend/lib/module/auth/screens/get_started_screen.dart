import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/module/auth/screens/login_screen.dart';
import 'package:frontend/module/auth/screens/sign_up_screen.dart';
import 'package:frontend/module/notify/screens/error-notify.dart';
import 'package:frontend/providers/auth_provider.dart';

class GetStarted extends ConsumerStatefulWidget {
  const GetStarted({super.key});

  @override
  ConsumerState<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends ConsumerState<GetStarted> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleGetStarted() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showErrorNotify(
        context,
        'Missing Information',
        'Please enter your email address.',
      );
      return;
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      showErrorNotify(
        context,
        'Invalid Email',
        'Please enter a valid email address.',
      );
      return;
    }

    final authRepository = ref.read(authRepositoryProvider);

    try {
      final emailExists = await authRepository.checkEmailExists(email);

      if (emailExists) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(email: email)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen(email: email)),
        );
      }
    } catch (e) {
      if (e.toString().contains('404')) {
        showErrorNotify(
          context,
          'Error',
          'The server is not responding. Please try again later.',
        );
      } else {
        showErrorNotify(
          context,
          'Error',
          'An error occurred while checking the email. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Center(
              child: Text(
                "Ready to watch?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Enter your email to create or sign in to your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: _handleGetStarted,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    "GET STARTED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
