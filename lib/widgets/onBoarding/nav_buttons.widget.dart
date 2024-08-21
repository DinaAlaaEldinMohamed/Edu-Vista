import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class NavButtons extends StatelessWidget {
  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;

  const NavButtons(
      {required this.onNextTap, required this.onPreviousTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: onPreviousTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorUtility.greyColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        // Forward button
        GestureDetector(
          onTap: onNextTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorUtility.secondaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
