import 'package:edu_vista/screens/auth/forgot_password_screen.dart';
import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/auth/password_reset_confirmation.dart';
import 'package:edu_vista/screens/auth/signup_screen.dart';
import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/screens/courses/courses_list_screen.dart';
import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:edu_vista/screens/onBoarding/onboarding_screen.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    final dynamic data = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case OnboardingScreen.route:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case LoginScreen.route:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case SignUpScreen.route:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case ForgotPasswordScreen.route:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case PasswordResetConfirmationScreen.route:
        final oobCode = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PasswordResetConfirmationScreen(oobCode: oobCode),
        );
      case HomeScreen.route:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case CategoriesScreen.route:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case CoursesListScreen.route:
        return MaterialPageRoute(builder: (_) => const CoursesListScreen());
      case CourseDetailsScreen.route:
        return MaterialPageRoute(
            builder: (_) => CourseDetailsScreen(
                  courseData: data,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
