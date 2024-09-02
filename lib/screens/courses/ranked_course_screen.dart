import 'package:edu_vista/screens/layout/base_layout.dart';
import 'package:flutter/material.dart';

class RankedCourseScreen extends StatefulWidget {
  static const String route = 'ranked_courses';
  const RankedCourseScreen({super.key});

  @override
  State<RankedCourseScreen> createState() => _RankedCourseScreenState();
}

class _RankedCourseScreenState extends State<RankedCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return const BaseLayout(body: Text('Ranked courses'));
  }
}
