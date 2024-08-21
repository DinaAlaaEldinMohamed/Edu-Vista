import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/courses.dart';
import 'package:edu_vista/models/instructors.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          return const Center(child: Text('Error fetching data'));
        }
        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const SizedBox(height: 40);
        }

        var coursesWithInstructors = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1 / 16),
          itemCount: coursesWithInstructors.length,
          itemBuilder: (context, index) {
            final courseData = coursesWithInstructors[index];
            final course = courseData['course'] as Course;
            final instructorName = courseData['instructorName'] as String;

            return SizedBox(
              width: 160,
              height: 205,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 105,
                    width: 160,
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
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchCombinedData() async {
    final courseQuerySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rank)
        .orderBy('created_at', descending: true)
        .get();

    final instructorFutures =
        <Future<DocumentSnapshot<Map<String, dynamic>>>>[];
    final courses = courseQuerySnapshot.docs.map((doc) {
      final course = Course.fromFirestore(doc);
      instructorFutures.add(course.instructor
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (snapshot, _) => snapshot.data()!,
            toFirestore: (instructor, _) => {},
          )
          .get());
      return course;
    }).toList();

    final instructorSnapshots = await Future.wait(instructorFutures);
    final instructorMap = <String, String>{};
    for (var snapshot in instructorSnapshots) {
      if (snapshot.exists) {
        final instructorData = Instructor.fromFirestore(snapshot);
        instructorMap[snapshot.id] = instructorData.name ?? '';
      }
    }
    final coursesWithInstructors = courses.map((course) {
      return {
        'course': course,
        'instructorName':
            instructorMap[course.instructor.id] ?? 'Instructor not found'
      };
    }).toList();

    return coursesWithInstructors;
  }
}
