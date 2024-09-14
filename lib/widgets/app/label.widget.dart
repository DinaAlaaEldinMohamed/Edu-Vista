import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';

class LabelTextwidget extends StatelessWidget {
  final String label;
  final String linkText;

  void Function()? onPressed;
  LabelTextwidget(
      {required this.label, required this.linkText, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          label,
          style: TextUtils.titleTextStyle,
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              linkText,
              style: TextUtils.smallTextStyle,
            ))
      ]),
    );
  }
}
