import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/course.dart';
import 'package:edu_vista/models/category.dart';
import 'package:edu_vista/repositoy/course_repo.dart';
import 'package:edu_vista/services/ranking.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQuerySubmitted>(_handleSearchQuerySubmitted);
    on<SearchQueryChanged>(_handleSearchQueryChanged);
    on<FetchTrendingTags>(_fetchTrendingTags);
    on<FetchUserSearchTags>(_fetchUserSearchTags);
  }

  Future<void> _handleSearchQuerySubmitted(
      SearchQuerySubmitted event, Emitter<SearchState> emit) async {
    final query = event.query;

    if (query.isEmpty) {
      await _fetchDefaultContent(emit);
    } else {
      await _performSearch(query, emit);
    }
  }

  Future<void> _handleSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query;

    if (query.isEmpty) {
      await _fetchDefaultContent(emit);
    } else {
      await _performSearch(query, emit);
    }
  }

  Future<void> _fetchDefaultContent(Emitter<SearchState> emit) async {
    emit(SearchInProgress());

    try {
      final trendingTagsSnapshot =
          await FirebaseFirestore.instance.collection('trending_tags').get();
      final userSearchTagsSnapshot = await FirebaseFirestore.instance
          .collection('user_searches')
          .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
          .get();

      final trendingTags = trendingTagsSnapshot.docs
          .map((doc) => doc['name'].toString())
          .toList();

      List<String> userSearchTags = userSearchTagsSnapshot.exists
          ? List<String>.from(userSearchTagsSnapshot['terms'])
          : [];

      emit(TagsLoaded(trendingTags, userSearchTags));
    } catch (e) {
      emit(SearchFailure('Failed to fetch default content: $e'));
    }
  }

  Future<void> _performSearch(String query, Emitter<SearchState> emit) async {
    emit(SearchInProgress());
    print(
        'performSearch=============================================================================$query');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(SearchFailure('User not logged in'));
        return;
      }

      final userId = user.uid;
      final userRef =
          FirebaseFirestore.instance.collection('user_searches').doc(userId);

      final resultsSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      final searchResults =
          resultsSnapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
      if (searchResults.isNotEmpty) {
        final firstCourseTitle = searchResults.first.title;
        final sanitizedCourseTitle = _sanitizeString(firstCourseTitle ?? '');

        if (firstCourseTitle != null && firstCourseTitle.isNotEmpty) {
          await userRef.set({
            'terms': FieldValue.arrayUnion([firstCourseTitle])
          }, SetOptions(merge: true));
        }

        await RankingService()
            .updateStudentAlsoSearchRank(searchResults.first.id);

        final trendingTagRef = FirebaseFirestore.instance
            .collection('trending_tags')
            .doc(sanitizedCourseTitle);
        await trendingTagRef.set(
            {'name': firstCourseTitle ?? '', 'count': FieldValue.increment(1)},
            SetOptions(merge: true));

        final courseRepository = CourseRepository();
        final instructorFutures = searchResults
            .map((course) => courseRepository.fetchInstructorData(course))
            .toList();
        final instructors = await Future.wait(instructorFutures);

        final courseAndInstructor =
            List.generate(searchResults.length, (index) {
          final instructorData = instructors[index];
          final instructorName = instructorData?.name ?? 'Unknown';
          return {
            'course': searchResults[index],
            'instructorName': instructorName,
          };
        });

        emit(SearchCourseSuccess(courseAndInstructor));
      } else {
        await _searchCategoriesOrStoreQuery(query, userRef);
      }
    } catch (e) {
      emit(SearchFailure('Search failed: $e'));
    }
  }

  Future<void> _searchCategoriesOrStoreQuery(
      String query, DocumentReference userRef) async {
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final categoryResults = categoriesSnapshot.docs.map((doc) {
      return Category.fromJson({
        'id': doc.id,
        ...doc.data(),
      });
    }).toList();

    if (categoryResults.isNotEmpty) {
      final firstCategoryName = categoryResults.first.name;
      final sanitizedCategoryName = _sanitizeString(firstCategoryName ?? '');

      if (firstCategoryName != null && firstCategoryName.isNotEmpty) {
        await userRef.set({
          'terms': FieldValue.arrayUnion([firstCategoryName])
        }, SetOptions(merge: true));
      }

      final trendingTagRef = FirebaseFirestore.instance
          .collection('trending_tags')
          .doc(sanitizedCategoryName);
      await trendingTagRef.set(
          {'name': firstCategoryName ?? '', 'count': FieldValue.increment(1)},
          SetOptions(merge: true));

      emit(SearchCategorySuccess(categoryResults));
    } else {
      await _storeQueryAsTrendingTag(query, userRef);
      emit(SearchFailure(
          'No results found for "$query", stored as a trending tag'));
    }
  }

  Future<void> _storeQueryAsTrendingTag(
      String query, DocumentReference userRef) async {
    final sanitizedQuery = _sanitizeString(query);

    await userRef.set({
      'terms': FieldValue.arrayUnion([query])
    }, SetOptions(merge: true));

    final trendingTagRef = FirebaseFirestore.instance
        .collection('trending_tags')
        .doc(sanitizedQuery);
    await trendingTagRef.set({'name': query, 'count': FieldValue.increment(1)},
        SetOptions(merge: true));
  }

  String _sanitizeString(String input) {
    return input.replaceAll('/', '_');
  }

  Future<void> _fetchTrendingTags(
      FetchTrendingTags event, Emitter<SearchState> emit) async {
    emit(SearchInProgress());

    try {
      final trendingSnapshot = await FirebaseFirestore.instance
          .collection('trending_tags')
          .orderBy('count', descending: true)
          .limit(5)
          .get();

      final trendingTags =
          trendingSnapshot.docs.map((doc) => doc['name'].toString()).toList();

      final currentState = state;
      if (currentState is TagsLoaded) {
        emit(TagsLoaded(trendingTags, currentState.userSearchTags));
      } else {
        emit(TagsLoaded(trendingTags, []));
      }
    } catch (e) {
      emit(SearchFailure('Failed to fetch trending tags: $e'));
    }
  }

  Future<void> _fetchUserSearchTags(
      FetchUserSearchTags event, Emitter<SearchState> emit) async {
    emit(SearchInProgress());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(SearchFailure('User not logged in'));
        return;
      }

      final userId = user.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('user_searches')
          .doc(userId)
          .get();

      List<String> userTags =
          userSnapshot.exists ? List<String>.from(userSnapshot['terms']) : [];
      print(
          '===========================================================user tags $userTags');

      final currentState = state;
      if (currentState is TagsLoaded) {
        emit(TagsLoaded(currentState.trendingTags, userTags.take(5).toList()));
      } else {
        emit(TagsLoaded([], userTags.take(5).toList()));
      }
    } catch (e) {
      emit(SearchFailure('Failed to fetch user search tags: $e'));
    }
  }
}
