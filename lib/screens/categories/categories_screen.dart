import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const String route = '/categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        'Categories',
        style: TextUtils.bodyTextStyle,
      ),
    ));
  }
}
