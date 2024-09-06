import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<CartItem>> getCartItems() async {
    final snapshot = await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .get();

    final cartItems = await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();
      final cartItem = CartItem.fromFirestore(data);

      // Fetch course data for each cart item
      final courseDoc =
          await _firestore.collection('courses').doc(cartItem.courseId).get();
      final course = Course.fromFirestore(courseDoc);

      return cartItem.copyWith(course: course);
    }).toList());

    print('Fetched cart items: ${cartItems.map((item) => item.id).toList()}');
    return cartItems;
  }

  Future<void> addCartItem(CartItem item) async {
    final cartRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(item.id);

    final docSnapshot = await cartRef.get();
    if (!docSnapshot.exists) {
      await cartRef.set(item.toJson());
    }
  }

  Future<void> removeCartItem(String itemId) async {
    await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  Future<void> addCourseToPurchased(String courseId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference purchasedCourseDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchasedCourses')
          .doc(courseId);

      await purchasedCourseDoc.set({
        'purchaseDate': FieldValue.serverTimestamp(),
        'courseId': courseId,
      });
    }
  }

  Future<void> updateCartAfterPurchase(String purchasedItemId) async {
    await removeCartItem(purchasedItemId);

    final updatedCartItems = await getCartItems();
    print('Updated Cart Items: $updatedCartItems');
  }
}
