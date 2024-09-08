part of 'lecture_bloc.dart';

abstract class LectureEvent {}

class LectureChosenEvent extends LectureEvent {
  final Lecture lecture;

  LectureChosenEvent(this.lecture);
}

class LectureEventInitial extends LectureEvent {}

class ResetLectureEvent extends LectureEvent {}

class MarkLectureAsWatchedEvent extends LectureEvent {
  final String lectureId;
  final String userId;
  final String courseId;

  MarkLectureAsWatchedEvent(
      {required this.lectureId, required this.userId, required this.courseId});
}
