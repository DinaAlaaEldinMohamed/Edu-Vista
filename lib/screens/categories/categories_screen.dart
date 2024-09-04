import 'package:edu_vista/home_page.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/repositoy/categories_repo.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:edu_vista/widgets/categories/category_course.widget.dart';
import 'package:edu_vista/widgets/app/custom_expansion_tile.widget.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const String route = '/categories';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryRepository categoryRepository = CategoryRepository();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: ColorUtility.primaryColor,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.route, (Route<dynamic> route) => false);
          },
        ),
        title: const Center(
            child: Text('Categories', style: TextUtils.headlineStyle)),
        actions: const [
          CartIconButton(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: FutureBuilder<List<Category>>(
            future: categoryRepository.fetchCategories(),
            builder: (context, categorySnapshot) {
              if (categorySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (categorySnapshot.hasError) {
                return Center(child: Text('Error: ${categorySnapshot.error}'));
              }

              if (!categorySnapshot.hasData || categorySnapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }

              final categories = categorySnapshot.data!;
              print(
                  'Fetched categories: ${categories.map((c) => c.toJson()).toList()}');

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  print('Category ${index}: ${category.toJson()}');

                  final categoryId = category.id;
                  if (categoryId == null) {
                    return const ListTile(title: Text('Category ID is null'));
                  }

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: categoryRepository
                        .fetchCoursesWithInstructors(categoryId),
                    builder: (context, courseSnapshot) {
                      if (courseSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                            title: Text('Loading courses...'));
                      }

                      if (courseSnapshot.hasError) {
                        return ListTile(
                            title: Text('Error: ${courseSnapshot.error}'));
                      }

                      final coursesWithInstructors = courseSnapshot.data ?? [];
                      print(
                          'Fetched courses for category $categoryId: ${coursesWithInstructors.map((c) => c['course']?.toFirestore()).toList()}');

                      return CustomExpansionTile(
                        title: category.name ?? 'Unknown Category',
                        children: [
                          CategoryCoursesWidget(
                            categoryName: category.name ?? 'Unknown Category',
                            coursesWithInstructors: coursesWithInstructors,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
