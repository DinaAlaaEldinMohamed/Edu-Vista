import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/screens/courses/courses_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseRepository {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // Update or create user progress
  Future<void> updateOrCreateUserProgress(String courseId) async {
    final progressRef = FirebaseFirestore.instance
        .collection('course_user_progress')
        .doc(userId);

    try {
      final docSnapshot = await progressRef.get();
      if (docSnapshot.exists) {
        // Document exists, update it
        await progressRef.update({
          courseId: FieldValue.increment(1),
        });
      } else {
        // Document does not exist, create it
        await progressRef.set({
          courseId: 1,
        });
      }
    } catch (e) {
      print('Error updating or creating user progress: $e');
    }
  }

  Future<List<Course>> getUserPurchasedCourses() async {
    List<String> purchasedCourseIds = await fetchPurchasedCourses();
    List<Course> courses = [];

    // Fetch course details for each purchased course
    for (String courseId in purchasedCourseIds) {
      DocumentSnapshot courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      courses.add(Course.fromFirestore(courseDoc));
    }

    return courses;
  }

  Future<List<String>> fetchPurchasedCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the user's purchasedCourses subcollection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchasedCourses')
          .get();

      // Extract course IDs
      List<String> purchasedCourseIds =
          querySnapshot.docs.map((doc) => doc.id).toList();
      return purchasedCourseIds;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getUserCoursesWithProgress() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the user's purchasedCourses subcollection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchasedCourses')
          .get();

      List<Map<String, dynamic>> userCourses = [];

      for (var doc in querySnapshot.docs) {
        String courseId = doc.id;
        DocumentSnapshot courseDoc = await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();
        Course course = Course.fromFirestore(courseDoc);

        // Fetch progress
        DocumentSnapshot progressDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('course_user_progress')
            .doc(courseId)
            .get();
        Map<String, dynamic>? progressData =
            progressDoc.data() as Map<String, dynamic>?;

        if (progressData == null) {
          print('No progress data found for course ID: $courseId');
        } else {
          print('Progress data for course ID: $courseId: $progressData');
        }

        double? progress = progressData?['progress']?.toDouble();

        print('Progress for course ID: $courseId: $progress'); // Debugging line

        userCourses.add({
          'course': course,
          'progress': progress,
        });
      }

      return userCourses;
    }
    return [];
  }
}
