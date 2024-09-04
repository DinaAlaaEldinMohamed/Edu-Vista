part of 'course_bloc.dart';

abstract class CourseEvent {}

class CourseFetchEvent extends CourseEvent {
  final Course course;

  CourseFetchEvent(this.course);
}

class CourseOptionChosenEvent extends CourseEvent {
  final CourseOptions courseOptions;

  CourseOptionChosenEvent(this.courseOptions);
}

class ResetCourseEvent extends CourseEvent {}
