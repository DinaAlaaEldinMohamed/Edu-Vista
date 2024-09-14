import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/screens/categories/category_courses_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  var futureCall = FirebaseFirestore.instance
      .collection('categories')
      .orderBy('order', descending: false)
      .get();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: FutureBuilder(
            future: futureCall,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text('Error fetching data');
              }
              if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
                return const SizedBox(height: 40);
              }
              var categories = List<Category>.from(snapshot.data?.docs
                      .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                      .toList() ??
                  []);
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryCoursesScreen(
                          category: categories[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: ColorUtility.lightGreyColor,
                          borderRadius: BorderRadius.circular(42)),
                      child: Center(
                        child: Text(
                          categories[index].name ?? 'No Name',
                          style: TextUtils.subheadline,
                        ),
                      )),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
              );
            }));
  }
}
