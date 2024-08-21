import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/auth/signup_screen.dart';
import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/courses_screen.dart';
import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:edu_vista/screens/onBoarding/onboarding_screen.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case OnboardingScreen.route:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case LoginScreen.route:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case SignUpScreen.route:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case HomeScreen.route:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case CategoriesScreen.route:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case CoursesScreen.route:
        return MaterialPageRoute(builder: (_) => const CoursesScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
