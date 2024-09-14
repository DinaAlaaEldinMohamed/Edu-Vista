import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/instructors.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/repositoy/lectures_repo.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/functions.dart';
import 'package:edu_vista/utils/images_utils.dart';
import 'package:edu_vista/widgets/app/custom_expansion_tile.widget.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';
import 'package:edu_vista/widgets/app/custom_rich_text.dart';
import 'package:edu_vista/widgets/app/full_screen_image_dialog.widget.dart';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:path_provider/path_provider.dart'; // Add this package to handle downloads

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
  Future<List<Lecture>>? _downloadedLecturesFuture;
  Instructor? instructor;
  final CourseRepository _courseRepository = CourseRepository();
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

  final LectureRepository _lectureRepository = LectureRepository();
  Future<void> _fetchLectures() async {
    final lastSeenLectureId =
        await _lectureRepository.fetchLastSeenLectureId(widget.course.id);

    setState(() {
      _lecturesFuture = FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .collection('lectures')
          .orderBy('sort')
          .get()
          .then((result) {
        final lectures = result.docs
            .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
            .toList();

        final defaultLecture = Lecture.fromJson({
          'id': '',
          'title': '',
          'description': '',
          'duration': 0,
          'sort': 0,
          'watched_users': [],
        });

        final lastSeenLecture = lectures.firstWhere(
          (lecture) => lecture.id == lastSeenLectureId,
          orElse: () => lectures.isNotEmpty ? lectures.first : defaultLecture,
        );

        setState(() {
          selectedLecture = lastSeenLecture;
        });

        return lectures;
      });
      _downloadedLecturesFuture =
          _lectureRepository.fetchDownloadedLectures(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        return _buildLectureOptionBody();
      case CourseOptions.Download:
        return _buildDownloadOptionBody();
      case CourseOptions.Certificate:
        return widget.course.hasCertificate == true
            ? Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog(widget.course.certificate);
                  },
                  child: Image.network(widget.course.certificate),
                ),
              )
            : const SizedBox.shrink();

      case CourseOptions.More:
        return _buildMoreOptionBody();
      default:
        return Container();
    }
  }

//---------------------------------------Build Lecture Option Body---------------------------------------------------
  Widget _buildLectureOptionBody() {
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
                          onPressed: () {
                            _lectureRepository.downloadLecture(
                                lecture, context, widget.course.id);
                          },
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
  }
//---------------------------------------Build Download Option Body---------------------------------------------------

  Widget _buildDownloadOptionBody() {
    return FutureBuilder<List<Lecture>>(
      future: _downloadedLecturesFuture,
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
            const Color activeColor = Colors.white;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorUtility.secondaryColor,
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
                        Icon(
                          Icons.done_all,
                          color: activeColor,
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
  }
//---------------------------------------Build More Option Body-------------------------------------------------------

  Widget _buildMoreOptionBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            FutureBuilder<Instructor?>(
              future: _courseRepository
                  .fetchInstructorData(widget.course), // Fetch instructor data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading instructor data');
                } else if (snapshot.hasData) {
                  final instructor = snapshot.data;
                  return CustomExpansionTile(
                    title: 'About Instructor',
                    children: [
                      instructor != null
                          ? Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomRichText(
                                        label: 'Name: ',
                                        value: instructor.name ?? 'Unknown'),
                                    CustomRichText(
                                        label: 'Experience: ',
                                        value:
                                            '${instructor.experienceYears ?? 'Unknown'} years'),
                                    CustomRichText(
                                        label: 'Certificate: ',
                                        value: instructor.certificate ??
                                            'Unknown'),
                                  ]),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'No instructor data available',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            CustomExpansionTile(title: 'Course Resources', children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _courseRepository
                          .fetchCourseResources(widget.course.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child:
                                Center(child: Text('Error loading resources')),
                          );
                        } else if (snapshot.hasData) {
                          final resources = snapshot.data!;
                          if (resources.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child:
                                  Center(child: Text('No resources available')),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: resources.map((resource) {
                                Widget icon;

                                switch (resource['type']) {
                                  case 'PDF':
                                    icon = const Icon(Icons.picture_as_pdf);
                                    break;
                                  case 'Video':
                                    icon = const Icon(Icons.video_library);
                                    break;
                                  default:
                                    icon = Image.asset(
                                      ImagesUtils.linkIcon,
                                      width: 25,
                                      height: 25,
                                    );
                                }
                                return ListTile(
                                  leading: icon,
                                  title: Text(resource['title']),
                                  onTap: () {
                                    _openResource(resource['url']);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ]),
            CustomExpansionTile(title: 'Share this Course', children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.facebook, color: Colors.blue),
                      title: const Text('Share on Facebook'),
                      onTap: () {
                        _shareCourse('Share on Facebook');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.blue),
                      title: const Text('Share on Twitter'),
                      onTap: () {
                        _shareCourse('Share on Twitter');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text('Share via Email'),
                      onTap: () {
                        _shareCourse('Share via Email');
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

//---------------------------------------Open course resources---------------------------------------------------------
  void _openResource(String url) {
    launchUrl(Uri.parse(url));
  }

//---------------------------------------Share Cource ----------------------------------------------------------------
  void _shareCourse(String platform) async {
    final result = await Share.share('Check out this amazing course!');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing my course!');
    }
  }

//---------------------------------------Show certificate image   ---------------------------------------------------------
  void _showImageDialog(String imageUrl) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return FullScreenImageDialog(imageUrl: imageUrl);
      },
    );
  }
}
