part of 'lecture_bloc.dart';

sealed class LectureState {}

final class LectureInitial extends LectureState {}

class LectureChosenState extends LectureState {
  final Lecture lecture;
  LectureChosenState(this.lecture);
}

class LectureErrorState extends LectureState {
  final String error;

  LectureErrorState(this.error);
}
