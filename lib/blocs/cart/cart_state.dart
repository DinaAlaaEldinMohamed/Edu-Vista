part of 'cart_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoadInProgress extends CartState {}

class CartLoadSuccess extends CartState {
  final List<CartItem> cartItems;

  CartLoadSuccess(this.cartItems);
}

class CartLoadFailure extends CartState {
  final String error;

  CartLoadFailure(this.error);
}

class CartCheckoutInProgress extends CartState {}

class CartCheckoutSuccess extends CartState {}

class CartCheckoutFailure extends CartState {
  final String error;

  CartCheckoutFailure(this.error);
}
