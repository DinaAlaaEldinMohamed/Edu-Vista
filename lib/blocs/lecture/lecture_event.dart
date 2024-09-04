part of 'lecture_bloc.dart';

abstract class LectureEvent {}

class LectureChosenEvent extends LectureEvent {
  final Lecture lecture;

  LectureChosenEvent(this.lecture);
}

class LectureEventInitial extends LectureEvent {}

class ResetLectureEvent extends LectureEvent {}
