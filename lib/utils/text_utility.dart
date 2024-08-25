import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextUtils {
  static const bodyTextStyle =
      TextStyle(fontSize: 15, color: ColorUtility.blackColor);
  static const labelTextStyle = TextStyle(
      fontSize: 17,
      color: ColorUtility.blackColor,
      fontWeight: FontWeight.w700);
  static const smallTextStyle = TextStyle(
      fontSize: 13,
      color: ColorUtility.blackColor,
      fontWeight: FontWeight.w600);

  static const ratingTextstyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff060302));
  static const titleTextStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff060302));
  static const priceTextStyle = TextStyle(
      color: ColorUtility.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.w800);
  static const headlineStyle = TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: ColorUtility.blackColor);
  static const subheadline = TextStyle(
      fontSize: 14,
      color: ColorUtility.blackColor,
      fontWeight: FontWeight.w400);
}
