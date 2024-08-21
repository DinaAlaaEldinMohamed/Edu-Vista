import 'package:edu_vista/screens/categories/categories_screen.dart';
import 'package:edu_vista/screens/courses/courses_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:edu_vista/widgets/app/label.widget.dart';
import 'package:edu_vista/widgets/categories/category.widget.dart';
import 'package:edu_vista/widgets/courses/course.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            children: [
              const TextSpan(
                text: 'Welcome ',
                style: TextStyle(color: ColorUtility.blackColor),
              ),
              TextSpan(
                text: user?.displayName ?? '',
                style: const TextStyle(color: ColorUtility.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              ImagesUtils.cartIcon,
              width: 22,
              height: 22,
            ),
            tooltip: 'shopping cart',
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: SingleChildScrollView(
          child: Column(children: [
            LabelTextwidget(
                label: 'Categories',
                linkText: 'See All',
                route: CategoriesScreen.route),
            CategoryWidget(),
            LabelTextwidget(
                label: 'Top Courses in IT',
                linkText: 'See All',
                route: CoursesScreen.route),
            CourseWidget(rank: 'top rated')
          ]),
        ),
      ),
    );
  }
}
