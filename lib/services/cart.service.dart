import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Future<List<CartItem>> getCartItems() async {
    final snapshot = await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .get();

    return snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
  }

  Future<void> addCartItem(CartItem item) async {
    await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .add(item.toJson());
  }

  Future<void> removeCartItem(String itemId) async {
    await _firestore
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(itemId)
        .delete();
  }
}
