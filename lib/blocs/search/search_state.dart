part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchInProgress extends SearchState {}

class SearchCourseSuccess extends SearchState {
  final List<Map<String, dynamic>> results;

  SearchCourseSuccess(this.results);
}

class SearchCourseFailure extends SearchState {
  final String error;

  SearchCourseFailure(this.error);
}

class SearchCategorySuccess extends SearchState {
  final List<Category> results;

  SearchCategorySuccess(this.results);
}

class SearchCategoryFailure extends SearchState {
  final String error;

  SearchCategoryFailure(this.error);
}

class TagsLoaded extends SearchState {
  final List<String> trendingTags;
  final List<String> userSearchTags;

  TagsLoaded(this.trendingTags, this.userSearchTags);
}

class SearchFailure extends SearchState {
  final String error;

  SearchFailure(this.error);
}
