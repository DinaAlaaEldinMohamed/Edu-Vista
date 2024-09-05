import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_item.dart';
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

    final cartItems =
        snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
    print(
        'Fetched cart items cart ftech item: ${cartItems.map((item) => item.id).toList()}'); // Logging
    return cartItems;
  }

  Future<void> addCartItem(CartItem item) async {
    final cartRef = _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(item.id);

    // Check if the item already exists in the cart
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
    // Remove the purchased item from the cart
    await removeCartItem(purchasedItemId);

    // Fetch updated cart items to verify the item is removed
    final updatedCartItems = await getCartItems();
    print('Updated Cart Items: $updatedCartItems'); // Debugging line
  }
}
