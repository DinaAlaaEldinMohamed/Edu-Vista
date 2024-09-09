part of 'course_options_bloc.dart';

abstract class CourseOptionsEvent {}

class FetchLecturesEvent extends CourseOptionsEvent {
  final String courseId;

  FetchLecturesEvent(this.courseId);
}

class DownloadLectureEvent extends CourseOptionsEvent {
  final Lecture lecture;

  DownloadLectureEvent(this.lecture);
}
