import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user ID from FirebaseAuth
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return BlocProvider(
      create: (context) => CartBloc()
        ..add(CartFetchEvent(userId!)), // Fetch cart with the current user ID
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is CartLoadFailure) {
              return Center(child: Text(state.error));
            }
            if (state is CartLoadSuccess) {
              final cartItems = state.cartItems;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(item.title),
                    subtitle: Text('\$${item.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(CartItemRemovedEvent(item.id));
                      },
                    ),
                  );
                },
              );
            }
            return Center(child: Text('No items in cart'));
          },
        ),
      ),
    );
  }
}
