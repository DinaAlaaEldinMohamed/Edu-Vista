import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:edu_vista/screens/onBoarding/onboarding_screen.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/colors-utils.dart';
import 'package:edu_vista/utils/images-utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagesUtils.logo),
            const CircularProgressIndicator(
              color: ColorUtility.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 1));
    if (PreferncesService.isOnboardingSeen) {
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      Navigator.pushReplacementNamed(context, OnboardingScreen.route);
    }
  }
}
