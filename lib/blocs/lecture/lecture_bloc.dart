import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/lecture.dart';
import 'package:edu_vista/models/course.dart';

part 'lecture_event.dart';
part 'lecture_state.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  LectureBloc() : super(LectureInitial()) {
    on<LectureChosenEvent>(_onLectureChosen);
    on<LectureEventInitial>(_onLectureInitial);
    on<ResetLectureEvent>(_onResetLecture);
    on<MarkLectureAsWatchedEvent>(_onLectureMarkedAswatched);
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

  FutureOr<void> _onLectureMarkedAswatched(
      MarkLectureAsWatchedEvent event, Emitter<LectureState> emit) async {
    try {
      // Retrieve the course details
      DocumentSnapshot courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .get();
      Course course = Course.fromFirestore(courseDoc);

      // Retrieve the list of lectures for the course
      QuerySnapshot lecturesSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(event.courseId)
          .collection('lectures')
          .get();
      int totalLectures = lecturesSnapshot.docs.length;

      // Update user progress
      DocumentReference progressDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .collection('course_user_progress')
          .doc(event.courseId);

      DocumentSnapshot progressDoc = await progressDocRef.get();
      if (!progressDoc.exists) {
        await progressDocRef.set({
          'progress': 0.0,
          'watchedLectures': [],
          'lastSeenLectureId': event.lectureId // Set initial last seen lecture
        });
      }

      Map<String, dynamic>? progressData =
          progressDoc.data() as Map<String, dynamic>?;
      List<String>? watchedLectures =
          progressData?['watchedLectures']?.cast<String>();

      watchedLectures ??= [];

      if (!watchedLectures.contains(event.lectureId)) {
        watchedLectures.add(event.lectureId);
      }

      double progress = calculateProgress(totalLectures, watchedLectures);

      // Update progress and last seen lecture
      await progressDocRef.update({
        'progress': progress,
        'watchedLectures': watchedLectures,
        'lastSeenLectureId': event.lectureId // Update last seen lecture
      });
      final lectureDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.id)
          .collection('lectures')
          .doc(event.lectureId)
          .get();

// Emit the updated lecture state
      if (lectureDoc.exists && lectureDoc.data() != null) {
        Lecture updatedLecture = Lecture.fromJson({
          'id': lectureDoc.id,
          ...lectureDoc.data()!,
          // Use the null-aware operator
        });
        print(
            '============================================================================updatelecture ${updatedLecture.lectureUrl}');
        emit(LectureChosenState(updatedLecture));
      }
    } catch (e) {
      print('Error updating lecture as watched: $e');
      emit(LectureErrorState('Failed to mark lecture as watched'));
    }
  }

  double calculateProgress(int totalLectures, List<String> watchedLectures) {
    if (totalLectures == 0) return 0.0;
    return (watchedLectures.length / totalLectures) * 100;
  }
}
