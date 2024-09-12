import 'package:edu_vista/blocs/cart/cart_bloc.dart';

import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  static const String route = '/payment';
  final CartItem item;

  const PaymentScreen({
    super.key,
    required this.item,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isSelected = false;

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });

    if (_isSelected) {
      // Dispatch the checkout event
      context.read<CartBloc>().add(
            CartCheckoutEvent(
              widget.item.id,
              context,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: ColorUtility.primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Payment Method', style: TextUtils.headlineStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartLoadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              // else if (state is CartLoadSuccess) {
              //   Navigator.pushNamedAndRemoveUntil(
              //       context, CartScreen.route, (Route<dynamic> route) => false);
              // }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _toggleSelection,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: _isSelected ? Colors.white : Colors.grey[300],
                      border: Border.all(
                        color: _isSelected
                            ? ColorUtility.secondaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveText(
                          text: 'Card',
                          color: _isSelected
                              ? ColorUtility.secondaryColor
                              : Colors.black,
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isSelected
                                  ? ColorUtility.secondaryColor
                                  : Colors.white,
                              width: 6, // Thickness of the circle outline
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
