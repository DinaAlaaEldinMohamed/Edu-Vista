// cart_event.dart
part of 'cart_bloc.dart';

abstract class CartEvent {}

class CartFetchEvent extends CartEvent {
  final String userId;

  CartFetchEvent(this.userId);
}

class CartItemAddedEvent extends CartEvent {
  final CartItem cartItem;

  CartItemAddedEvent(this.cartItem);
}

class CartItemRemovedEvent extends CartEvent {
  final String cartItemId;

  CartItemRemovedEvent(this.cartItemId);
}