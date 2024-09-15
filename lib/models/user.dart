import 'package:cloud_firestore/cloud_firestore.dart';

class UserMetadata {
  String? phoneNumber;
  String? address;
  String? university;
  int? age;
  String? bio;
  List<String> purchasedCourses;

  UserMetadata({
    this.phoneNumber,
    this.address,
    this.university,
    this.age,
    this.bio,
    this.purchasedCourses = const [],
  });

  factory UserMetadata.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserMetadata(
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      university: data['university'],
      age: data['age'] as int?,
      bio: data['bio'],
      purchasedCourses: List<String>.from(data['purchasedCourses'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'address': address,
      'university': university,
      'age': age,
      'bio': bio,
      'purchasedCourses': purchasedCourses,
    };
  }

  void addPurchasedCourse(String courseId) {
    purchasedCourses.add(courseId);
  }
}
