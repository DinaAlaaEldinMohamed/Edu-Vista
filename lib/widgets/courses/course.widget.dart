import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/utils/app_widget_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseWidget extends StatefulWidget {
  final String rank;

  const CourseWidget({required this.rank, super.key});

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  late Future<List<Map<String, dynamic>>> combinedFuture;
  final CourseRepository courseRepository = CourseRepository();

  @override
  void initState() {
    super.initState();
    combinedFuture = courseRepository.fetchCourseAndInstructor(widget.rank);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: combinedFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching data: ${snapshot.error}'));
        }
        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const Center(child: Text('No courses available'));
        }

        var coursesWithInstructors = snapshot.data!;
        print('Fetched courses with instructors: $coursesWithInstructors');

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1 / 1.6,
          ),
          itemCount: coursesWithInstructors.length,
          itemBuilder: (context, index) {
            final courseData = coursesWithInstructors[index];
            final course = courseData['course'] as Course;
            final instructorName = courseData['instructorName'] as String;

            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, CourseDetailsScreen.route,
                    arguments: courseData);
              },
              child: SizedBox(
                width: 160.w,
                height: 250.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150.h,
                      width: 160.w,
                      child: Image.network(
                        course.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRatingStars(course.rating, 16),
                          Text(
                            course.title,
                            style: TextUtils.titleTextStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                height: 14,
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 18,
                                ),
                              ),
                              Text(instructorName),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' ${course.currency == 'dollar' ? '\$' : ''} ${course.price} ',
                                style: TextUtils.priceTextStyle,
                              ),
                              IconButton(
                                onPressed: () => courseRepository.addToCart(
                                    course.id, instructorName, context),
                                icon: const Icon(Icons.add_shopping_cart),
                                tooltip: 'Add to Cart',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
