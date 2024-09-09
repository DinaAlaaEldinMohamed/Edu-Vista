import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/services/ranking.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseRepository {
  final userId = FirebaseAuth.instance.currentUser!.uid;

//------------------------------- Fetch Courses And Instructor ---------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchCourseAndInstructor(
      String rank) async {
    try {
      final availableRankings = await RankingService().getAvailableRankings();

      // Check if the current rank is valid
      if (!availableRankings.contains(rank)) {
        return [];
      }
      final courseQuerySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('ranks', arrayContains: rank)
          .orderBy('created_at', descending: true)
          .get();
      if (courseQuerySnapshot.docs.isEmpty) {
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
      //fetch instructor data
      final instructorSnapshots = await Future.wait(instructorFutures);
      final instructors = instructorSnapshots.map((snapshot) {
        final data = snapshot.data();
        return data?['name'] ?? 'Unknown';
      }).toList();

      final courseAndInstructor = List.generate(courses.length, (index) {
        return {
          'course': courses[index],
          'instructorName': instructors[index],
        };
      });

      return courseAndInstructor;
    } catch (e) {
      return [];
    }
  }

//------------------------------- Add course to cart --------------------------------------------------------------

  Future<void> addToCart(
      String courseId, String instructorName, BuildContext context) async {
    try {
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Check if the item is already in the cart
      final cartItemsSnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();

      if (cartItemsSnapshot.docs.isNotEmpty) {
        // Item already exists in the cart
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This item is already in your cart'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Create a CartItem instance
      final cartItem = CartItem(
          id: DateTime.now().toString(),
          courseId: courseId,
          instructorName: instructorName);

      // Add the item to the user's cart in Firestore
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(cartItem.id)
          .set(cartItem.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error adding item to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to cart')),
      );
    }
  }
//------------------------------- Get User Courses With his progress-----------------------------------------------

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

        print('Progress for course ID: $courseId: $progress');

        print('Fetching instructor details...');
        // Fetch instructor details
        String instructorName = '';
        if (course.instructor != null) {
          DocumentSnapshot instructorDoc = await course.instructor.get();
          if (instructorDoc.exists) {
            instructorName =
                instructorDoc['name'] as String? ?? 'Unknown Instructor';
          }
        }
        userCourses.add({
          'course': course,
          'progress': progress,
          'instructorName': instructorName
        });
      }

      return userCourses;
    }
    return [];
  }
}
