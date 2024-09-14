import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:edu_vista/widgets/courses/course.widget.dart';
import 'package:flutter/material.dart';

class RankedCourseScreen extends StatefulWidget {
  static const String route = 'ranked_courses';
  final String rank;

  const RankedCourseScreen({required this.rank, super.key});

  @override
  State<RankedCourseScreen> createState() => _RankedCourseScreenState();
}

class _RankedCourseScreenState extends State<RankedCourseScreen> {
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
        title: Center(child: Text(widget.rank, style: TextUtils.headlineStyle)),
        actions: const [
          CartIconButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CourseWidget(rank: widget.rank),
          ],
        ),
      ),
    );
  }
}
