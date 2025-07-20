import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    _navigate();
    ;
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final seenOnboard = prefs.getBool('seenOnboard') ?? false;
    // Check if the user has seen the onboarding screen
    // If yes, navigate to login, otherwise to onboarding
    if (seenOnboard) {
      //Navigator.pushReplacementNamed(context, AppRoutes.login);
      context.go(AppRoutes.login);
    } else {
      //Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
      context.go(AppRoutes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo.jpg', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'Cozy Care',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
