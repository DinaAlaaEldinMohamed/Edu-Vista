import 'package:edu_vista/blocs/cart/cart_bloc.dart';
import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/cart/cart_item.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: ColorUtility.primaryColor,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.route, (Route<dynamic> route) => false);
            },
          ),
          title:
              const Center(child: Text('Cart', style: TextUtils.headlineStyle)),
        ),
        body: const Center(child: Text('User not logged in')),
      );
    }

    return BlocProvider(
      create: (context) => CartBloc()..add(CartFetchEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: ColorUtility.primaryColor,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.route, (Route<dynamic> route) => false);
            },
          ),
          title:
              const Center(child: Text('Cart', style: TextUtils.headlineStyle)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocConsumer<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartLoadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
              // if (state is CartCheckoutSuccess) {
              //   Navigator.pushNamed(context, CheckoutPage.route);
              // }
            },
            builder: (context, state) {
              if (state is CartLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CartLoadSuccess) {
                final cartItems = state.cartItems;
                if (cartItems.isEmpty) {
                  return const Center(child: Text('No items in cart'));
                }
                return CartListView(cartItems: cartItems);
              }
              return const Center(child: Text('No items in cart'));
            },
          ),
        ),
      ),
    );
  }
}

class CartListView extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartListView({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return CartItemTile(
          item: item,
          onCancel: () {
            context.read<CartBloc>().add(CartItemRemovedEvent(item.id));
          },
          onBuy: () {
            context.read<CartBloc>().add(CartCheckoutEvent(item.id, context));
          },
        );
      },
    );
  }
}
