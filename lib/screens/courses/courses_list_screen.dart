import 'package:flutter/material.dart';

class CoursesListScreen extends StatefulWidget {
  static const String route = '/courses';
  const CoursesListScreen({super.key});

  @override
  State<CoursesListScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('courses'));
  }
}
