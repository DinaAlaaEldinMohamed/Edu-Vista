import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/functions.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';
import 'package:flutter/material.dart';

class CourseOptionsWidgets extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;

  const CourseOptionsWidgets({
    required this.courseOption,
    required this.course,
    required this.onLectureChosen,
    super.key,
  });

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  Lecture? selectedLecture;
  Future<List<Lecture>>? _lecturesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.courseOption == CourseOptions.Lecture) {
      _fetchLectures();
    }
  }

  @override
  void didUpdateWidget(covariant CourseOptionsWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.courseOption == CourseOptions.Lecture &&
        oldWidget.course.id != widget.course.id) {
      _fetchLectures();
    }
  }

  Future<void> _fetchLectures() async {
    setState(() {
      _lecturesFuture = FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .collection('lectures')
          .orderBy('sort')
          .get()
          .then((result) {
        return result.docs
            .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        return FutureBuilder<List<Lecture>>(
          future: _lecturesFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || (snapshot.data?.isEmpty ?? false)) {
              return const Center(
                child: Text('No Lectures found'),
              );
            }

            final lectures = snapshot.data!;

            return GridView.count(
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(lectures.length, (index) {
                final lecture = lectures[index];
                final Color activeColor;
                selectedLecture?.id == lecture.id
                    ? activeColor = Colors.white
                    : activeColor = Colors.black;

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedLecture?.id == lecture.id
                        ? ColorUtility.secondaryColor
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ResponsiveText(
                              text: 'Lecture ${lecture.sort}',
                              color: activeColor,
                            )),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.download_sharp,
                                  size: 20, color: activeColor),
                            )
                          ],
                        ),
                        ResponsiveText(
                          text: lecture.title ?? 'No Name',
                          fontWeight: FontWeight.w400,
                          color: activeColor,
                        ),
                        Flexible(
                          child: Text(
                            lecture.description ?? 'No Description',
                            style: TextStyle(
                                color: activeColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Duration ${formatDuration(lecture.duration)}',
                                style: TextStyle(
                                    color: activeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                widget.onLectureChosen(lecture);
                                setState(() {
                                  selectedLecture = lecture;
                                });
                              },
                              icon: Icon(Icons.play_circle_outline_outlined,
                                  size: 40, color: activeColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        );

      case CourseOptions.Download:
      case CourseOptions.Certificate:
      case CourseOptions.More:
        return const SizedBox.shrink();

      default:
        return Text('Invalid option ${widget.courseOption}');
    }
  }
}
