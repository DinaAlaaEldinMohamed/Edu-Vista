import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? obscureText;

  AppTextFormField({
    required this.hintText,
    this.keyboardType,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText ?? false,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: ColorUtility.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: ColorUtility.darkGreyColor),
              ),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
