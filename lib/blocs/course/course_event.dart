part of 'course_bloc.dart';

sealed class CourseEvent {}

class CourseFetchEvent extends CourseEvent {
  final Course course;

  CourseFetchEvent(this.course);
}

class CourseOptionChosenEvent extends CourseEvent {
  final CourseOptions courseOptions;

  CourseOptionChosenEvent(this.courseOptions);
}

class LectureChosenEvent extends CourseEvent {
  final Lecture lecture;
  LectureChosenEvent(this.lecture);
}
