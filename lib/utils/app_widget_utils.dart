import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';

Widget buildRatingStars(double rating, double starSize) {
  // Adjust this value to your desired star size

  return Row(
    children: [
      Text(
        rating.toStringAsFixed(1),
        style: TextUtils.ratingTextstyle,
      ),
      const SizedBox(width: 8),
      Row(
        children: List.generate(
          5,
          (starIndex) {
            if (starIndex < rating.floor()) {
              return Icon(
                Icons.star,
                color: ColorUtility.primaryColor,
                size: starSize, // Set the size of the star icon
              );
            } else if (starIndex < rating) {
              return Icon(
                Icons.star_half,
                color: ColorUtility.primaryColor,
                size: starSize, // Set the size of the star icon
              );
            } else {
              return Icon(
                Icons.star_border,
                color: ColorUtility.primaryColor,
                size: starSize, // Set the size of the star icon
              );
            }
          },
        ),
      ),
    ],
  );
}
