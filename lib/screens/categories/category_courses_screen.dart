import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:edu_vista/widgets/courses/course.widget.dart';
import 'package:flutter/material.dart';

import 'package:edu_vista/models/category.dart';

class CategoryCoursesScreen extends StatefulWidget {
  final Category category;

  const CategoryCoursesScreen({super.key, required this.category});

  @override
  State<CategoryCoursesScreen> createState() => _CategoryCoursesScreenState();
}

class _CategoryCoursesScreenState extends State<CategoryCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: ColorUtility.primaryColor,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.route, (Route<dynamic> route) => false);
            },
          ),
          title: Center(
              child: Text('${widget.category.name}',
                  style: TextUtils.headlineStyle)),
          actions: const [
            CartIconButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: CourseWidget(
            rank: '',
            categoryId: widget.category.id ?? '',
          ),
        ));
  }
}
