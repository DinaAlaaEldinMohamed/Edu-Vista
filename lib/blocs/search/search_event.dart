part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class FetchTrendingTags extends SearchEvent {}

class FetchUserSearchTags extends SearchEvent {}

class SearchQuerySubmitted extends SearchEvent {
  final String query;

  SearchQuerySubmitted(this.query);
}
