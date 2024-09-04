import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String courseId;
  final String title;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.courseId,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CartItem(
      id: doc.id,
      courseId: data['courseId'] as String,
      title: data['title'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
    );
  }
}
