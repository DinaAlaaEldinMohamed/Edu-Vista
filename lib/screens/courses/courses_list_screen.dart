import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return const PurchasedCoursesList();
  }
}

class PurchasedCoursesList extends StatelessWidget {
  const PurchasedCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseRepository courseRepository = CourseRepository();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: courseRepository
          .getUserCoursesWithProgress(), // Function to get user courses with progress
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No purchased courses found.'),
          );
        } else {
          List<Map<String, dynamic>> userCourses = snapshot.data!;
          return ListView.builder(
            itemCount: userCourses.length,
            itemBuilder: (context, index) {
              final courseData = userCourses[index];
              final course = courseData['course'] as Course;
              final progress = courseData['progress'] as double?;
              print('progress:=======================$progress');
              final progressText = progress == null
                  ? 'Start Now'
                  : 'Progress: ${progress.toStringAsFixed(0)}%';

              return ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(course.title),
                subtitle: Text(progressText),
                leading:
                    course.image != null ? Image.network(course.image!) : null,
                trailing: ElevatedButton(
                  onPressed: () {
                    if (progress == null) {
                    } else {}
                  },
                  child: Text(progress == null ? 'Start Now' : 'Continue'),
                ),
              );
            },
          );
        }
      },
    );
  }
}
