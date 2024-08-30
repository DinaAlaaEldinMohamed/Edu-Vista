import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCoursesWidget extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> coursesWithInstructors;

  const CategoryCoursesWidget({
    Key? key,
    required this.categoryName,
    required this.coursesWithInstructors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1 / 1.5, // Adjust aspect ratio as needed
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
                                } else if (starIndex < course.rating.floor()) {
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
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 5),
                      Text(
                        ' ${course.currency == 'dollar' ? '\$' : ''} ${course.price} ',
                        style: TextUtils.priceTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
