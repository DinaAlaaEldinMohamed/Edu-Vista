import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String id;
  String title;
  String image;
  DocumentReference category; // Reference to Category document
  DocumentReference instructor; // Reference to Instructor document
  double duration;
  double rating;
  double price;
  Timestamp createdAt;
  bool hasCertificate;
  String currency;
  String rank;
  //int enrollments;
  //Map<String, int> rankings;
  Course({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.rating,
    required this.price,
    required this.createdAt,
    required this.hasCertificate,
    required this.currency,
    required this.rank,
    //required this.enrollments,
    // required this.rankings,
  });

  // Factory method to create a Course instance from a Firestore document
  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      title: data['title'],
      image: data['image'],
      category: data['category'] is DocumentReference
          ? data['category'] as DocumentReference
          : FirebaseFirestore.instance.doc(data['category'] as String),
      instructor: data['instructor'] is DocumentReference
          ? data['instructor'] as DocumentReference
          : FirebaseFirestore.instance.doc(data['instructor'] as String),
      duration: data['duration'] is int
          ? (data['duration'] as int).toDouble()
          : data['duration'],
      rating: data['rating'] is int
          ? (data['rating'] as int).toDouble()
          : data['rating'],
      price: data['price'] is int
          ? (data['price'] as int).toDouble()
          : data['price'],
      createdAt: data['created_at'],
      hasCertificate: data['has_certificate'],
      currency: data['currency'],
      rank: data['rank'],
      // enrollments: data['enrollments'],
      //rankings: data['rankings'],
    );
  }

  // Method to convert a Course instance to a Firestore-friendly format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'image': image,
      'category': category,
      'instructor': instructor,
      'duration': duration,
      'rating': rating,
      'price': price,
      'created_at': createdAt,
      'has_certificate': hasCertificate,
      'currency': currency,
      'rank': rank,
    };
  }
}
