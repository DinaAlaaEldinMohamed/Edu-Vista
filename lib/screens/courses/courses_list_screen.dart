import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return PurchasedCoursesList();
  }
}

class PurchasedCoursesList extends StatelessWidget {
  const PurchasedCoursesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: getUserPurchasedCourses(), // Function to get purchased courses
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
          return const Center(
            child: Text('No purchased courses found.'),
          );
        } else {
          List<Course> purchasedCourses = snapshot.data!;
          return ListView.builder(
            itemCount: purchasedCourses.length,
            itemBuilder: (context, index) {
              Course course = purchasedCourses[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(course.title),
                subtitle: Text('Instructor:  Instructor name'),
                // ignore: unnecessary_null_comparison
                leading: course.image != null
                    ? Image.network(course
                        .image) // Assuming imageUrl is a property of Course
                    : null,
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CourseDetailPage(course: course), // CourseDetailPage should be implemented separately
                  //   ),
                  // );
                },
              );
            },
          );
        }
      },
    );
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
}
