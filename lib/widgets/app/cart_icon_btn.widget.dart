import 'package:edu_vista/cart_page.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:flutter/material.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        ImagesUtils.cartIcon,
        width: 22,
        height: 22,
      ),
      tooltip: 'Shopping Cart',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      },
    );
  }
}
