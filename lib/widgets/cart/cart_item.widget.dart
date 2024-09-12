import 'package:edu_vista/models/cart_item.dart';
import 'package:edu_vista/screens/cart/payment_screen.dart';
import 'package:edu_vista/utils/app_widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista/widgets/app/appButtons/app_elvated_btn.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';

class CartItemTile extends StatefulWidget {
  final CartItem item;
  final Function() onCancel;
  final Function() onBuy;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onCancel,
    required this.onBuy,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  bool _isExpanded = false;
  bool _isBuyNowClicked = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleBuyNow() {
    setState(() {
      _isBuyNowClicked = true;
    });
  }

  void _navigateToPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          item: widget.item,
        ),
      ),
    );
  }

  void _handleCancel() {
    setState(() {
      _isBuyNowClicked = false;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleExpanded,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: widget.item.course?.image != null
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.network(
                            widget.item.course!.image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image, size: 100),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveText(
                          text: widget.item.course?.title ?? 'No title',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 14),
                            const SizedBox(width: 4),
                            ResponsiveText(
                              text: widget.item.instructorName,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        buildRatingStars(widget.item.course?.rating ?? 0, 16),
                        ResponsiveText(
                          text: '\$${widget.item.course?.price ?? 0}',
                          color: ColorUtility.primaryColor,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                  color: _isExpanded
                      ? ColorUtility.secondaryColor
                      : ColorUtility.primaryColor,
                ),
              ],
            ),
          ),
          // If Buy Now button is not clicked, display Buy Now button and cancel button
          if (!_isBuyNowClicked && _isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: AppElvatedBtn(
                        onPressed: _handleCancel, // Collapse tile on cancel
                        backgroundColor: ColorUtility.greyColor,
                        child: const ResponsiveText(
                          text: 'Cancel',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppElvatedBtn(
                      onPressed:
                          _handleBuyNow, // Show checkout and remove on press
                      backgroundColor: ColorUtility.secondaryColor,
                      child: const ResponsiveText(
                        text: 'Buy Now',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_isExpanded &&
              _isBuyNowClicked) // Display Checkout and Remove after expanding and clicking Buy Now
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: AppElvatedBtn(
                      onPressed: widget.onCancel,
                      backgroundColor: ColorUtility.greyColor,
                      child: const ResponsiveText(
                        text: 'Remove',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    fit: FlexFit.loose,
                    child: AppElvatedBtn(
                      onPressed: _navigateToPaymentPage,
                      backgroundColor: ColorUtility.secondaryColor,
                      child: const ResponsiveText(
                        text: 'Checkout',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
