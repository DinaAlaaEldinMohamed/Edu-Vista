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
  List<String> ranks;
  int enrollments;

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
    required this.ranks,
    required this.enrollments,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Safely casting to Map

    if (data == null) {
      throw Exception('Document does not exist or data is null');
    }

    return Course(
      id: doc.id,
      title: data['title'] as String? ??
          'Unknown Title', // Providing fallback values
      image: data['image'] as String? ??
          '', // Provide default image or handle null case
      category: data['category'] is DocumentReference
          ? data['category'] as DocumentReference
          : FirebaseFirestore.instance.doc(data['category'] as String? ?? ''),
      instructor: data['instructor'] is DocumentReference
          ? data['instructor'] as DocumentReference
          : FirebaseFirestore.instance.doc(data['instructor'] as String? ?? ''),
      duration: data['duration'] is int
          ? (data['duration'] as int).toDouble()
          : (data['duration'] as double? ?? 0.0),
      rating: data['rating'] is int
          ? (data['rating'] as int).toDouble()
          : (data['rating'] as double? ?? 0.0),
      price: data['price'] is int
          ? (data['price'] as int).toDouble()
          : (data['price'] as double? ?? 0.0),
      createdAt: data['created_at'] as Timestamp? ?? Timestamp.now(),
      hasCertificate: data['has_certificate'] as bool? ?? false,
      currency: data['currency'] as String? ?? 'USD',
      ranks: List<String>.from(data['ranks'] ?? []),
      enrollments: data['enrollments'] as int? ?? 0,
    );
  }

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
      'ranks': ranks,
      'enrollments': enrollments,
    };
  }
}
