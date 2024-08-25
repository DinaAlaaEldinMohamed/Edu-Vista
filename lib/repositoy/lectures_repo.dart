// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:edu_vista/models/lecture.dart';

// class LectureRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Lecture>> getLecturesForCourse(String courseId) async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('courses')
//           .doc(courseId)
//           .collection('lectures')
//           .get();

//       List<Lecture> lectures =
//           snapshot.docs.map((doc) => Lecture.fromFirestore(doc)).toList();

//       return lectures;
//     } catch (e) {
//       print('Error getting lectures: $e');
//       return [];
//     }
//   }
// }
