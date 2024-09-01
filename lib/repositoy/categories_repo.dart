import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/instructors.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    try {
      final QuerySnapshot categorySnapshot =
          await _firestore.collection('categories').orderBy('order').get();
      final categories = categorySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCoursesWithInstructors(
      String categoryId) async {
    try {
      final QuerySnapshot courseSnapshot = await _firestore
          .collection('courses')
          .where('category',
              isEqualTo: _firestore.doc('categories/$categoryId'))
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
