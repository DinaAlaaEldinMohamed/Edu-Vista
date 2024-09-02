import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/onBoarding/onboarding_screen.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/services/ranking.service.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    super.initState();
    _startApp();
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
    await _updateRankings();

    if (PreferncesService.isOnboardingSeen) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, HomePage.route);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.route);
      }
    } else {
      Navigator.pushReplacementNamed(context, OnboardingScreen.route);
    }
  }

  Future<void> _updateRankings() async {
    try {
      await RankingService().updateCourseRankings();
    } catch (e) {
      print('Failed to update rankings: $e');
      // You might want to show an error message or handle the failure accordingly
    }
  }
}
