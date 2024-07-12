import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Make sure you have your LoginScreen defined somewhere
// For example:

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // Correct placement of then()
    Future.delayed(const Duration(seconds: 3)).then((_) {

// Suggested code may be subject to a license. Learn more: ~LicenseLog:2728680866.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:362416638.
      if (auth.currentUser == null) {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/journal.png',
            height: 100,
          ),
          const SizedBox(height: 16), // Add some spacing
          
        ],
      ),
    ));
  }
}
