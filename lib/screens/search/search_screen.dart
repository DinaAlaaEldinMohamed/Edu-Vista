import 'package:edu_vista/blocs/search/search_bloc.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/screens/categories/category_courses_screen.dart';
import 'package:edu_vista/screens/courses/course_destails_screen.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/widgets/app/cart_icon_btn.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_vista/models/course.dart';

class SearchScreen extends StatelessWidget {
  static const String route = '/search';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(FetchTrendingTags());
    context.read<SearchBloc>().add(FetchUserSearchTags());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  void _onSearchSubmitted() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(SearchQuerySubmitted(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSearchBox(),
            const SizedBox(width: 5),
            const CartIconButton(),
          ],
        ),
        // actions: const [
        //   CartIconButton(),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is SearchInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchInitial) {
              return const Center(
                  child: Text('Search for courses or categories.'));
            } else if (state is TagsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trending',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildTagsRow(context, state.trendingTags),
                    const SizedBox(height: 16),
                    const Text(
                      'Based on your Search',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildTagsRow(context, state.userSearchTags),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            } else if (state is SearchCourseSuccess) {
              return _buildCourseList(state.results);
            } else if (state is SearchCategorySuccess) {
              return _buildCategoryList(state.results);
            } else {
              return const Center(
                  child: Text('Search for courses or categories.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 276,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: '  Search...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchSubmitted, // Handle search on button press
          ),
        ),
        onChanged: (value) {
          _onSearchTextChanged(value); // Handle search on text change
        },
        onSubmitted: (_) => _onSearchSubmitted(),
      ),
    );
  }

  Widget _buildTagsRow(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: 8,
      children: tags.map((tag) {
        return GestureDetector(
          onTap: () {
            context.read<SearchBloc>().add(SearchQuerySubmitted(tag));
          },
          child: Chip(
            labelPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(8),
            side: BorderSide.none,
            shape: const StadiumBorder(),
            label: Text(tag),
            backgroundColor: ColorUtility.greyColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourseList(List<Map<String, dynamic>> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final courseData = courses[index];
        final course = courseData['course'] as Course;
        final courseInstructor = courseData['instructorName'] as String;

        if (course == null) {
          return const SizedBox();
        }

        return ListTile(
          leading: Image.network(course.image),
          title: Text(course.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(courseInstructor),
              const SizedBox(height: 8),
              Text('${course.price}'),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(
                  courseData: courseData,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.name ?? ''),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryCoursesScreen(
                  category: category,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
