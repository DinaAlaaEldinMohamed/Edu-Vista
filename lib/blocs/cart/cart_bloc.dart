import 'dart:async';
import 'package:edu_vista/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartFetchEvent>(_onFetchCartItems);
    on<CartItemAddedEvent>(_onAddCartItem);
    on<CartItemRemovedEvent>(_onRemoveCartItem);
  }

  FutureOr<void> _onFetchCartItems(
      CartFetchEvent event, Emitter<CartState> emit) async {
    emit(CartLoadInProgress());
    try {
      final cartItemsQuery = await FirebaseFirestore.instance
          .collection('carts')
          .doc(event.userId)
          .collection('items')
          .get();

      final cartItems = cartItemsQuery.docs.map((doc) {
        return CartItem.fromFirestore(doc);
      }).toList();

      emit(CartLoadSuccess(cartItems));
    } catch (e) {
      emit(CartLoadFailure('Failed to load cart items: $e'));
    }
  }

  FutureOr<void> _onAddCartItem(
      CartItemAddedEvent event, Emitter<CartState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(event.cartItem.id)
          .set(event.cartItem.toJson());

      // Fetch updated cart items
      add(CartFetchEvent(userId));
    } catch (e) {
      emit(CartLoadFailure('Failed to add item to cart: $e'));
    }
  }

  FutureOr<void> _onRemoveCartItem(
      CartItemRemovedEvent event, Emitter<CartState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(event.cartItemId)
          .delete();

      // Fetch updated cart items
      add(CartFetchEvent(userId));
    } catch (e) {
      emit(CartLoadFailure('Failed to remove item from cart: $e'));
    }
  }
}
