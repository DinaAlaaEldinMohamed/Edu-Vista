part of 'course_bloc.dart';

sealed class CourseState {}

final class CourseInitial extends CourseState {}

class CourseOptionStateChanges extends CourseState {
  final CourseOptions courseOption;

  CourseOptionStateChanges(this.courseOption);
}

// For lectures
class LectureState extends CourseState {}

class LectureChosenState extends LectureState {
  final Lecture lecture;
  LectureChosenState(this.lecture);
}

// Error state
class CourseErrorState extends CourseState {
  final String message;
  CourseErrorState(this.message);
}
