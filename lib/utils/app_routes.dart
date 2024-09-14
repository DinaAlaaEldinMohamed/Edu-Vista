import 'package:edu_vista/screens/cart/cart_screen.dart';
import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/screens/auth/forgot_password_screen.dart';
import 'package:edu_vista/screens/auth/login_screen.dart';
import 'package:edu_vista/screens/auth/password_reset_confirmation.dart';
import 'package:edu_vista/screens/auth/signup_screen.dart';
import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/screens/courses/courses_list_screen.dart';
import 'package:edu_vista/screens/courses/ranked_course_screen.dart';
import 'package:edu_vista/screens/home/chat_screen.dart';
import 'package:edu_vista/screens/search/search_screen.dart';
import 'package:edu_vista/screens/onBoarding/onboarding_screen.dart';
import 'package:edu_vista/screens/profile/profile_screen.dart';
import 'package:edu_vista/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    final dynamic arguments = settings.arguments;
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
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (_) => PasswordResetConfirmationScreen(oobCode: arguments),
          );
        }
        return _errorRoute(); // Handle invalid argument type
      case HomePage.route:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case CategoriesScreen.route:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case ProfileScreen.route:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case CoursesListScreen.route:
        return MaterialPageRoute(builder: (_) => const CoursesListScreen());
      case ChatScreen.route:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case SearchScreen.route:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case CartScreen.route:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case CourseDetailsScreen.route:
        if (arguments is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => CourseDetailsScreen(
              courseData: arguments,
            ),
          );
        }
        return _errorRoute(); // Handle invalid argument type
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Error: Invalid route arguments')),
      ),
    );
  }
}
