import 'package:edu_vista/blocs/course/course_bloc.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/utils/text_utility.dart';
import 'package:edu_vista/widgets/courses/course_chips.widget.dart';
import 'package:edu_vista/widgets/courses/course_options.widget.dart';
import 'package:edu_vista/widgets/lectures/video_box.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_box/video_box.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  static const String route = '/course_details';
  //final Course course;

  const CourseDetailsScreen({required this.courseData, super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    final course = widget.courseData['course'] as Course;
    context.read<CourseBloc>().add(CourseFetchEvent(course));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courseData['course'] as Course;
    final instructorName = widget.courseData['instructorName'] as String;
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<CourseBloc, CourseState>(builder: (ctx, state) {
          if (state is! LectureState) return const SizedBox();
          var stateEx = state is LectureChosenState ? state : null;
          if (stateEx == null) {
            return const SizedBox.shrink();
          }
          return Container(
            height: 250,
            child: stateEx.lecture.lectureUrl == null ||
                    stateEx.lecture.lectureUrl == ''
                ? const Center(
                    child: Text(
                    'Invalid Url',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ))
                : VideoBoxWidget(
                    url: stateEx.lecture.lectureUrl ?? '',
                  ),
          );
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<CourseBloc, CourseState>(
            buildWhen: (previous, current) => current is LectureState,
            builder: (context, state) {
              var applyChanges = (state is LectureChosenState) ? true : false;
              return AnimatedContainer(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: applyChanges
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))
                        : null),
                duration: const Duration(seconds: 3),
                alignment: Alignment.bottomCenter,
                height: applyChanges
                    ? MediaQuery.sizeOf(context).height - 220
                    : null,
                curve: Curves.easeInOut,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          course.title,
                          style: TextUtils.headlineStyle,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          instructorName,
                          style: TextUtils.subheadline,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: BlocBuilder<CourseBloc, CourseState>(
                              builder: (ctx, state) {
                            print('>>>>>>>>build ${state}');
                            return Column(
                              children: [
                                CourseChipsWidget(
                                  selectedOption:
                                      (state is CourseOptionStateChanges)
                                          ? state.courseOption
                                          : null,
                                  onChanged: (courseOption) {
                                    context.read<CourseBloc>().add(
                                        CourseOptionChosenEvent(courseOption));
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                    child: (state is CourseOptionStateChanges)
                                        ? CourseOptionsWidgets(
                                            course: context
                                                .read<CourseBloc>()
                                                .course!,
                                            courseOption: state.courseOption,
                                            onLectureChosen: (lecture) {
                                              context.read<CourseBloc>().add(
                                                  LectureChosenEvent(lecture));
                                            },
                                          )
                                        : const SizedBox.shrink())
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
