import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/instructors.dart';
import 'package:edu_vista/widgets/categories/category_course.widget.dart';
import 'package:edu_vista/widgets/categories/custom_expansion_tile.widget.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const String route = '/categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories and Courses'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Category>>(
            future: _fetchCategories(),
            builder: (context, categorySnapshot) {
              if (categorySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (categorySnapshot.hasError) {
                return Center(child: Text('Error: ${categorySnapshot.error}'));
              }

              if (!categorySnapshot.hasData || categorySnapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }

              final categories = categorySnapshot.data!;
              print(
                  'Fetched categories: ${categories.map((c) => c.toJson()).toList()}');

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  print('Category ${index}: ${category.toJson()}');

                  final categoryId = category.id;
                  if (categoryId == null) {
                    return ListTile(title: Text('Category ID is null'));
                  }

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchCoursesWithInstructors(categoryId),
                    builder: (context, courseSnapshot) {
                      if (courseSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                            title: Text('Loading courses...'));
                      }

                      if (courseSnapshot.hasError) {
                        return ListTile(
                            title: Text('Error: ${courseSnapshot.error}'));
                      }

                      final coursesWithInstructors = courseSnapshot.data ?? [];
                      print(
                          'Fetched courses for category $categoryId: ${coursesWithInstructors.map((c) => c['course']?.toFirestore()).toList()}');

                      return CustomExpansionTile(
                        title: category.name ?? 'Unknown Category',
                        children: [
                          CategoryCoursesWidget(
                            categoryName: category.name ?? 'Unknown Category',
                            coursesWithInstructors: coursesWithInstructors,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<Category>> _fetchCategories() async {
    try {
      final QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('order')
          .get();
      final categories = categorySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
      print(
          'Categories fetched: ${categories.map((c) => c.toJson()).toList()}');
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCoursesWithInstructors(
      String categoryId) async {
    try {
      final QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('category',
              isEqualTo:
                  FirebaseFirestore.instance.doc('categories/$categoryId'))
          .get();

      final instructorFutures =
          <Future<DocumentSnapshot<Map<String, dynamic>>>>[];
      final courses = courseSnapshot.docs.map((doc) {
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
    } catch (e) {
      print('Error fetching combined data: $e');
      return [];
    }
  }
}
