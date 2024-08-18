import 'package:edu_vista/utils/colors-utils.dart';
import 'package:flutter/material.dart';

class AppElvatedBtn extends StatelessWidget {
  final Color backgroundColor;
  double? horizontal;
  Widget? child;
  String? title;

  final Color textColor;
  void Function() onPressed;

  // final double width;
  // final double height;
  AppElvatedBtn(
      {this.backgroundColor = ColorUtility.secondaryColor,
      this.textColor = Colors.white,
      this.horizontal,
      this.child,
      this.title,
      required this.onPressed,
      super.key}) {
    assert(
        child != null || title != null, 'child Or Text must not equal to null');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          : child,
    );
  }
}
