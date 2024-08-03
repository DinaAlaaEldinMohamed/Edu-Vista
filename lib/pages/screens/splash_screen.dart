import 'package:edu_vista/pages/screens/onBoarding/onboarding-screen.dart';
import 'package:edu_vista/utils/images-utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
    return Scaffold(
      body: Center(child: Image.asset(ImagesUtils.logo)),
    );
  }
}
