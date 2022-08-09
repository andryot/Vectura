part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool initialized;
  final int page;
  final int pageSize;
  final Failure? failure;

  const SearchState({
    required this.initialized,
    required this.page,
    required this.pageSize,
    required this.failure,
  });

  const SearchState.initial()
      : initialized = false,
        page = 0,
        pageSize = 10,
        failure = null;

  SearchState copyWith({
    bool? initialized,
    int? page,
    int? pageSize,
    Failure? failure,
  }) {
    return SearchState(
      initialized: initialized ?? this.initialized,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      failure: failure,
    );
  }
}
