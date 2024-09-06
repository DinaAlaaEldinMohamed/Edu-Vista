import 'dart:async';
import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/services/cart.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService = CartService();

  CartBloc() : super(CartInitial()) {
    on<CartFetchEvent>(_onFetchCartItems);
    on<CartItemAddedEvent>(_onAddCartItem);
    on<CartItemRemovedEvent>(_onRemoveCartItem);
    on<CartCheckoutEvent>(_onCheckout);
  }

  FutureOr<void> _onFetchCartItems(
      CartFetchEvent event, Emitter<CartState> emit) async {
    emit(CartLoadInProgress());
    try {
      final cartItems = await _cartService.getCartItems();
      print('Fetched Cart Items: $cartItems'); // Debugging line
      emit(CartLoadSuccess(cartItems));
    } catch (e) {
      emit(CartLoadFailure('Failed to load cart items: $e'));
    }
  }

  FutureOr<void> _onAddCartItem(
      CartItemAddedEvent event, Emitter<CartState> emit) async {
    try {
      await _cartService.addCartItem(event.cartItem);
      add(CartFetchEvent(FirebaseAuth.instance.currentUser?.uid ?? ''));
    } catch (e) {
      emit(CartLoadFailure('Failed to add item to cart: $e'));
    }
  }

  FutureOr<void> _onRemoveCartItem(
      CartItemRemovedEvent event, Emitter<CartState> emit) async {
    try {
      await _cartService.removeCartItem(event.cartItemId);
      add(CartFetchEvent(FirebaseAuth.instance.currentUser?.uid ?? ''));
    } catch (e) {
      emit(CartLoadFailure('Failed to remove item from cart: $e'));
    }
  }

  FutureOr<void> _onCheckout(
      CartCheckoutEvent event, Emitter<CartState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Fetch all cart items
      final cartItems = await _cartService.getCartItems();
      print(
          'Cart items before checkout: ${cartItems.map((item) => item.id).toList()}'); // Logging

      // Find the specific item being purchased
      final cartItem = cartItems.firstWhere(
        (item) => item.id == event.cartItemId,
        orElse: () => throw Exception('Item not found in cart'),
      );

      PaymobPayment.instance.initialize(
        apiKey: dotenv.get('API_KEY'),
        integrationID: int.parse(dotenv.get('integrationID')),
        iFrameID: int.parse(dotenv.get('iFrameID')),
      );

      // Ensure amountInCents is calculated correctly
      final amountInCents = (cartItem.course?.price ?? 0) * 100 * 50;

      final PaymobResponse? response = await PaymobPayment.instance.pay(
        context: event.context,
        currency: "EGP",
        amountInCents: amountInCents.toString(), // Convert amount to string
      );

      if (response != null) {
        if (response.success == true) {
          await _cartService.removeCartItem(event.cartItemId);

          await _cartService.addCourseToPurchased(cartItem.id);

          final updatedCartItems = await _cartService.getCartItems();
          print(
              'Updated cart items after checkout: ${updatedCartItems.map((item) => item.id).toList()}');

          emit(CartLoadSuccess(updatedCartItems));

          ScaffoldMessenger.of(event.context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(response.message ?? "Payment Done Successfully"),
            ),
          );
        } else {
          emit(CartLoadFailure(
              'Payment failed: ${response.message ?? 'Unknown error'}'));
        }
      }
    } catch (e) {
      emit(CartLoadFailure('Failed to checkout: $e'));
      print('checkout failed ============================$e');
    }
  }
}
