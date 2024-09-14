import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/ranked_course_screen.dart';
import 'package:edu_vista/widgets/app/label.widget.dart';
import 'package:edu_vista/widgets/categories/category.widget.dart';
import 'package:edu_vista/widgets/courses/course.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edu_vista/services/ranking.service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> rankTitles = [
    'Students Also Search For',
    'Top Courses in IT',
    'Top Sellers',
    'Because you Viewed',
    'Top Rated',
  ];

  @override
  void initState() {
    super.initState();
    _updateRankings();
  }

  Future<void> _updateRankings() async {
    try {
      await RankingService().updateCourseRankings();
    } catch (e) {
      print('Failed to update rankings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextwidget(
                label: 'Categories',
                linkText: 'See All',
                onPressed: () => Navigator.pushReplacementNamed(
                    context, CategoriesScreen.route),
              ),
              const CategoryWidget(),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rankTitles.length,
                itemBuilder: (context, index) {
                  final rankTitle = rankTitles[index];
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTextwidget(
                          label: rankTitle,
                          linkText: 'See All',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RankedCourseScreen(rank: rankTitle),
                              ),
                            );
                          },
                        ),
                        CourseWidget(rank: rankTitle),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
