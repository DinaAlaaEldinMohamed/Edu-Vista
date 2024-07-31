import 'package:edu_vista/pages/screens/onboarding-screen.dart';
import 'package:edu_vista/utils/colors-utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Edu Vista',
        theme: ThemeData(
          fontFamily: "PlusJakartaSans",
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorUtility.primaryColor),
          scaffoldBackgroundColor: ColorUtility.pageBackgroundColor,
          useMaterial3: true,
        ),
        home: const OnboardingScreen());
  }
}
