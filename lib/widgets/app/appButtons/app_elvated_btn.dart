import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppElvatedBtn extends StatelessWidget {
  final Color backgroundColor;
  double? horizontal;
  Widget? child;
  String? title;
  double? borderRadius;
  final Color textColor;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding; // Add this line

  AppElvatedBtn({
    this.backgroundColor = ColorUtility.secondaryColor,
    this.textColor = Colors.white,
    this.horizontal,
    this.child,
    this.title,
    required this.onPressed,
    this.borderRadius,
    this.padding, // Add this line
    super.key,
  }) {
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
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            )
          : child,
    );
  }
}
