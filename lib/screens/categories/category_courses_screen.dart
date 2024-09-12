import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:flutter/material.dart';

import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/models/course.dart';

class CategoryCoursesScreen extends StatefulWidget {
  final Category category;

  const CategoryCoursesScreen({super.key, required this.category});

  @override
  _CategoryCoursesScreenState createState() => _CategoryCoursesScreenState();
}

class _CategoryCoursesScreenState extends State<CategoryCoursesScreen> {
  final CourseRepository courseRepository = CourseRepository();

  late Future<List<Map<String, dynamic>>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture =
        courseRepository.fetchCoursesByCategory(widget.category.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses in ${widget.category.name}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses found.'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final courseData = courses[index];
                final course = courseData['course'] as Course;

                return ListTile(
                  title: Text(course.title),
                  subtitle: Text('${course.price}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsScreen(
                            courseData: courseData), // Adjust as needed
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
