import 'dart:async';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/services/ranking.service.dart';
import 'package:edu_vista/utils/app_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<CourseFetchEvent>(_onGetCourse);
    on<CourseOptionChosenEvent>(_onCourseOptionChosen);
    on<ResetCourseEvent>(_onResetCourse); // Handle the reset event
  }

  Course? _course;
  CourseOptions? _selectedOption;

  FutureOr<void> _onGetCourse(
      CourseFetchEvent event, Emitter<CourseState> emit) {
    _course = event.course;
    _selectedOption = CourseOptions.Lecture;
    if (_course != null) {
      RankingService().updateUserViewRank(_course!.id);
    }

    emit(CourseLoaded(_course!, _selectedOption!));
  }

  FutureOr<void> _onCourseOptionChosen(
      CourseOptionChosenEvent event, Emitter<CourseState> emit) {
    _selectedOption = event.courseOptions;

    if (_course != null) {
      emit(CourseLoaded(_course!, _selectedOption!));
    }
  }

  FutureOr<void> _onResetCourse(
      ResetCourseEvent event, Emitter<CourseState> emit) {
    _course = null;
    _selectedOption = null;
    emit(CourseInitial());
  }
}
