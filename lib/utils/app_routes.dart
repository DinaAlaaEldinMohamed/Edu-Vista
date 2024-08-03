import 'package:edu_vista/pages/screens/login/login.dart';
import 'package:edu_vista/pages/screens/onBoarding/onboarding-screen.dart';
import 'package:edu_vista/pages/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboard':
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const Login());

      default:
        return MaterialPageRoute(builder: (_) => const Login());
    }
  }
}
