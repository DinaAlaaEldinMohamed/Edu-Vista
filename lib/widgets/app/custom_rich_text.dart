import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  const CustomRichText(
      {required this.label,
      required this.value,
      this.labelColor = ColorUtility.primaryColor,
      this.valueColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: labelColor,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: valueColor,
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
