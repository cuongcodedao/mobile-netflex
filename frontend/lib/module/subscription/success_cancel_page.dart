import 'package:flutter/material.dart';
import 'package:frontend/module/auth/screens/login_screen.dart';
import 'package:frontend/services/storage_service.dart';

class CancelPlanPage extends StatelessWidget {
  const CancelPlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/images/netflex_logo.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              "Plan Cancelled",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Your subscription has been successfully cancelled. You will have access until the end of your billing period.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () async{
                StorageService storageService = StorageService();
                bool? isFirstInstall = await storageService.getFirstInstall();
                storageService.clearStorage();
                if(isFirstInstall != null){
                  storageService.saveFirstInstall(isFirstInstall);
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "Sign Out To Continue",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Montserrat",
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "You can subscribe again at any time to restore full access.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
