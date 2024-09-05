import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id; // Add this field
  final String courseId;
  final String title;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id, // Add this field to the constructor
    required this.courseId,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  // Convert a CartItem instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create a CartItem instance from a Firestore document snapshot
  factory CartItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CartItem(
      id: doc.id, // Use doc.id as the id
      courseId: data['courseId'] as String,
      title: data['title'] as String,
      price: (data['price'] as num).toDouble(), // Ensure price is double
      imageUrl: data['imageUrl'] as String,
    );
  }
}
