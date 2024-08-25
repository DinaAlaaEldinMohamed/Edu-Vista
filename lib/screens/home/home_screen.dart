import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/courses_list_screen.dart';
import 'package:edu_vista/screens/layout/base_layout.dart';
import 'package:edu_vista/widgets/app/label.widget.dart';
import 'package:edu_vista/widgets/categories/category.widget.dart';
import 'package:edu_vista/widgets/courses/course.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> rankTitles = [
    'Because you Viewed',
    'Students Also Search for',
    'Top Courses in IT',
    'Top Sellers',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelTextwidget(
                label: 'Categories',
                linkText: 'See All',
                route: CategoriesScreen.route,
              ),
              const CategoryWidget(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rankTitles.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelTextwidget(
                        label: rankTitles[index],
                        linkText: 'See All',
                        route: CoursesListScreen.route,
                      ),
                      const CourseWidget(rank: 'top rated'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
