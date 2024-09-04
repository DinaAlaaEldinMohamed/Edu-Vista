part of 'course_bloc.dart';

sealed class CourseState {}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final Course course;
  final CourseOptions courseOption;

  CourseLoaded(this.course, this.courseOption);
}
