import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/lecture.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';

part 'course_options_event.dart';
part 'course_options_state.dart';

class CourseOptionsBloc extends Bloc<CourseOptionsEvent, CourseOptionsState> {
  CourseOptionsBloc() : super(CourseOptionsInitial()) {
    on<FetchLecturesEvent>(_onFetchLectures);
    on<DownloadLectureEvent>(_onDownloadLecture);
  }

  FutureOr<void> _onFetchLectures(
      FetchLecturesEvent event, Emitter<CourseOptionsState> emit) async {
    try {
      emit(LecturesLoading());
      final lastSeenLectureId = await _fetchLastSeenLectureId(event.courseId);
      final lecturesSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .collection('lectures')
          .orderBy('sort')
          .get();
      final lectures = lecturesSnapshot.docs
          .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
          .toList();
      final defaultLecture = Lecture.fromJson({
        'id': '',
        'title': '',
        'description': '',
        'duration': 0,
        'sort': 0,
        'is_downloaded': false,
      });

      final lastSeenLecture = lectures.firstWhere(
        (lecture) => lecture.id == lastSeenLectureId,
        orElse: () => lectures.isNotEmpty ? lectures.first : defaultLecture,
      );

      emit(LecturesLoaded(lectures, lastSeenLecture));
    } catch (e) {
      emit(LecturesError("Error fetching lectures"));
    }
  }

  Future<String> _fetchLastSeenLectureId(String courseId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('course_user_progress')
        .doc(courseId)
        .get();
    return userDoc.data()?['lastSeenLectureId'] ?? '';
  }

  FutureOr<void> _onDownloadLecture(
      DownloadLectureEvent event, Emitter<CourseOptionsState> emit) async {
    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final taskId = await FlutterDownloader.enqueue(
        url: event.lecture.lectureUrl ?? '',
        savedDir: directory.path,
        fileName: '${event.lecture.title}.mp4',
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        emit(LectureDownloaded(event.lecture));
      }
    } catch (e) {
      emit(LectureDownloadError("Error downloading lecture"));
    }
  }
}
