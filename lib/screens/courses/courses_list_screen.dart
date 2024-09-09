import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';
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
      future: courseRepository.getUserCoursesWithProgress(),
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
          return Center(
            child: Image.asset(ImagesUtils.noCourses),
          );
        } else {
          List<Map<String, dynamic>> userCourses = snapshot.data!;
          return ListView.builder(
            itemCount: userCourses.length,
            itemBuilder: (context, index) {
              final courseData = userCourses[index];
              final course = courseData['course'] as Course;
              final progress = courseData['progress'] as double?;
              final instructorName = courseData['instructorName'] as String;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image
                    // ignore: unnecessary_null_comparison
                    course.image != null
                        ? SizedBox(
                            width: 157,
                            height: 105,
                            child: Image.network(
                              course.image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(
                            width: 157,
                            height: 105,
                            child: Image.asset(ImagesUtils.noCourses),
                          ),
                    const SizedBox(width: 16),
                    // Course Details (Title, Progress)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            text: course.title,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(
                                height: 14,
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 18,
                                ),
                              ),
                              ResponsiveText(
                                text: instructorName,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          progress == null
                              ? const ResponsiveText(
                                  text: 'Start your course',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ResponsiveText(
                                      text: 'Continue',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 10),
                                    LinearProgressIndicator(
                                      value: progress / 100,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              ColorUtility.secondaryColor),
                                      minHeight: 5,
                                    ),
                                    const SizedBox(height: 5),
                                    // Text(
                                    //   '${progress.toStringAsFixed(0)}% completed',
                                    //   style: const TextStyle(fontSize: 12),
                                    // ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
