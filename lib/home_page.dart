import 'package:edu_vista/screens/home/home_screen.dart';
import 'package:edu_vista/screens/layout/base_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(body: HomeScreen());
  }
}
