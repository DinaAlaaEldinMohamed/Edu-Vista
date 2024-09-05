import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Fetch user purchased courses
  Future<List<String>> getUserPurchasedCourses(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('purchasedCourses')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching user purchased courses: $e');
      return [];
    }
  }
}
