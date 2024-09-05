import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/widgets/courses/course_chips.widget.dart';
import 'package:edu_vista/widgets/courses/course_options.widget.dart';
import 'package:edu_vista/widgets/lectures/video_box.widget.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  static const String route = '/course_details';

  const CourseDetailsScreen({required this.courseData, super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final course = widget.courseData['course'] as Course;
    context.read<CourseBloc>().add(CourseFetchEvent(course));
    context.read<LectureBloc>().add(LectureEventInitial());
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courseData['course'] as Course;
    final instructorName = widget.courseData['instructorName'] as String;

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LectureBloc, LectureState>(builder: (ctx, state) {
            if (state is LectureChosenState) {
              return SizedBox(
                height: 232,
                child: state.lecture.lectureUrl == null ||
                        state.lecture.lectureUrl == ''
                    ? const Center(
                        child: Text(
                          'Invalid Url',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : VideoBoxWidget(
                        url: state.lecture.lectureUrl ?? '',
                      ),
              );
            }
            return const SizedBox.shrink();
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              duration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
              height: MediaQuery.sizeOf(context).height - 250,
              curve: Curves.easeInOut,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        instructorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _BodyWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorUtility.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CourseBloc, CourseState>(builder: (ctx, state) {
        if (state is CourseLoaded) {
          return Column(
            children: [
              CourseChipsWidget(
                selectedOption: state.courseOption,
                onChanged: (courseOption) {
                  context
                      .read<CourseBloc>()
                      .add(CourseOptionChosenEvent(courseOption));
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CourseOptionsWidgets(
                  course: state.course,
                  courseOption: state.courseOption,
                  onLectureChosen: (lecture) async {
                    // Reset LectureBloc state before selecting a new lecture
                    context.read<LectureBloc>().add(ResetLectureEvent());
                    final CourseRepository courseRepository =
                        CourseRepository();
                    await courseRepository
                        .updateOrCreateUserProgress(state.course.id);
                    context
                        .read<LectureBloc>()
                        .add(LectureChosenEvent(lecture));
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Error loading course details'));
      }),
    );
  }
}
