import 'package:edu_vista/utils/colors-utils.dart';
import 'package:flutter/material.dart';

class AppTextBtn extends StatelessWidget {
  String label;
  void Function()? onPressed;
  AppTextBtn({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            label,
            style: const TextStyle(
                color: ColorUtility.secondaryColor, fontSize: 15),
          ),
        ));
  }
}