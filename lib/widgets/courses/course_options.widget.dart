import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:edu_vista/utils/colors_utils.dart';
import 'package:edu_vista/utils/functions.dart';
import 'package:edu_vista/widgets/app/responsive_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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

  Future<String> _fetchLastSeenLectureId() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('course_user_progress')
        .doc(widget.course.id)
        .get();
    return userDoc.data()?['lastSeenLectureId'] ?? '';
  }

  Future<void> _fetchLectures() async {
    final lastSeenLectureId = await _fetchLastSeenLectureId();

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
      _downloadedLecturesFuture = _fetchDownloadedLectures();
    });
  }

  Future<List<Lecture>> _fetchDownloadedLectures() async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.course.id)
          .collection('lectures')
          .where('is_downloaded', isEqualTo: true)
          .orderBy('sort')
          .get();

      return result.docs
          .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
          .toList();
    } catch (e) {
      print('Error fetching downloaded lectures: $e');
      return [];
    }
  }

  Future<void> _downloadLecture(Lecture lecture) async {
    // Ensure FlutterDownloader is initialized
    // await FlutterDownloader.initialize();

    // Get the external storage directory
    // String _localPath = (await ExtStorage.getExternalStoragePublicDirectory(
    // ExtStorage.DIRECTORY_DOWNLOADS))!;
    // final directory = await getExternalStorageDirectory();
    Directory directory = Directory('/storage/emulated/0/Download');
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to access storage directory'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final savedDir = directory.path; // Ensure this directory exists

    // Create the directory if it does not exist
    final downloadDir = Directory('$savedDir');
    print(
        '=====================================================download directroy====$downloadDir');
    if (!downloadDir.existsSync()) {
      downloadDir.createSync(recursive: true);
    }

    final url = lecture.lectureUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No download URL available for this lecture'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadDir.path,
        fileName:
            '${lecture.title}.mp4', // Ensure this is a valid file extension
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download started'),
            backgroundColor: Colors.green,
          ),
        );
        _updateLectureDownloadStatus(lecture.id, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading lecture: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error downloading lecture: $e');
    }
  }

  Future<void> _updateLectureDownloadStatus(
      String? lectureId, bool isDownloaded) async {
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('courses')
        .doc(widget.course.id)
        .collection('lectures')
        .doc(lectureId)
        .update({
      'is_downloaded': true,
    });
    try {
      await firestore.collection('lectures').doc(lectureId).update({
        'is_downloaded': isDownloaded,
      });
      print('Lecture download status updated successfully');
    } catch (e) {
      print('Error updating lecture download status: $e');
    }
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
                              onPressed: () {
                                _downloadLecture(lecture);
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

      case CourseOptions.Download:
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
                final Color activeColor = Colors.white;

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

      default:
        return Container();
    }
  }
}
