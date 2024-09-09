part of 'course_options_bloc.dart';

abstract class CourseOptionsState {}

class CourseOptionsInitial extends CourseOptionsState {}

class LecturesLoading extends CourseOptionsState {}

class LecturesLoaded extends CourseOptionsState {
  final List<Lecture> lectures;
  final Lecture lastSeenLecture;

  LecturesLoaded(this.lectures, this.lastSeenLecture);
}

class LecturesError extends CourseOptionsState {
  final String errorMessage;

  LecturesError(this.errorMessage);
}

class LectureDownloaded extends CourseOptionsState {
  final Lecture lecture;

  LectureDownloaded(this.lecture);
}

class LectureDownloadError extends CourseOptionsState {
  final String errorMessage;

  LectureDownloadError(this.errorMessage);
}
