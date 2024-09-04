import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:edu_vista/models/lecture.dart';

part 'lecture_event.dart';
part 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(LectureInitial()) {
    on<LectureChosenEvent>(_onLectureChosen);
    on<LectureEventInitial>(_onLectureInitial);
    on<ResetLectureEvent>(_onResetLecture); // Handle the reset event
  }

  FutureOr<void> _onLectureInitial(
      LectureEventInitial event, Emitter<LectureState> emit) {
    emit(LectureInitial());
  }

  FutureOr<void> _onLectureChosen(
      LectureChosenEvent event, Emitter<LectureState> emit) {
    emit(LectureChosenState(event.lecture));
  }

  FutureOr<void> _onResetLecture(
      ResetLectureEvent event, Emitter<LectureState> emit) {
    print('ResetLectureEvent received');
    emit(LectureInitial());
  }
}
