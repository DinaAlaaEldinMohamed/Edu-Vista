import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/services/ranking.service.dart';
import 'package:edu_vista/utils/colors_utils.dart';
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

  @override
  void initState() {
    super.initState();
    combinedFuture = fetchCombinedData();
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
              childAspectRatio: 1 / 1.5), // Adjust aspect ratio as needed
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              course.rating.toStringAsFixed(1),
                              style: TextUtils.ratingTextstyle,
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) {
                                  if (starIndex < course.rating.floor()) {
                                    return const Icon(
                                      Icons.star,
                                      color: ColorUtility.primaryColor,
                                    );
                                  } else if (starIndex < course.rating) {
                                    return const Icon(
                                      Icons.star_half,
                                      color: ColorUtility.primaryColor,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.star_border,
                                      color: ColorUtility.primaryColor,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
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
                        Text(
                          ' ${course.currency == 'dollar' ? '\$' : ''} ${course.price} ',
                          style: TextUtils.priceTextStyle,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCombinedData() async {
    try {
      // Get available rankings
      print('Fetching available rankings...');
      final availableRankings = await RankingService().getAvailableRankings();
      print('Available rankings: $availableRankings');

      // Check if the current rank is valid
      if (!availableRankings.contains(widget.rank)) {
        print('Invalid rank: ${widget.rank}');
        return []; // Return an empty list if the rank is not valid
      }

      // Fetch courses based on the rank specified in the widget
      print('Fetching courses with rank: ${widget.rank}');
      final courseQuerySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('ranks', arrayContains: widget.rank)
          .orderBy('created_at', descending: true)
          .get();

      print('Number of courses found: ${courseQuerySnapshot.docs.length}');
      if (courseQuerySnapshot.docs.isEmpty) {
        print('No courses found for rank: ${widget.rank}');
        return []; // Return an empty list if no courses are found
      }

      final instructorFutures =
          <Future<DocumentSnapshot<Map<String, dynamic>>>>[];
      final courses = courseQuerySnapshot.docs.map((doc) {
        final course = Course.fromFirestore(doc);
        print('Course found: ${course.title}');
        instructorFutures.add(course.instructor
            .withConverter<Map<String, dynamic>>(
              fromFirestore: (snapshot, _) => snapshot.data()!,
              toFirestore: (instructor, _) => {},
            )
            .get());
        return course;
      }).toList();

      print('Fetching instructor details...');
      final instructorSnapshots = await Future.wait(instructorFutures);
      final instructors = instructorSnapshots.map((snapshot) {
        final data = snapshot.data();
        print('Instructor found: ${data?['name'] ?? 'Unknown'}');
        return data?['name'] ?? 'Unknown';
      }).toList();

      final combinedData = List.generate(courses.length, (index) {
        return {
          'course': courses[index],
          'instructorName': instructors[index],
        };
      });

      print('Combined data: $combinedData');
      return combinedData;
    } catch (e) {
      print('Error fetching combined data: $e');
      return [];
    }
  }
}
