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

  // Factory method to create UserMetadata from Firestore document data
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

  // Convert UserMetadata object to Firestore-friendly data
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

  // Add a course to the purchasedCourses list
  void addPurchasedCourse(String courseId) {
    purchasedCourses.add(courseId);
  }
}
