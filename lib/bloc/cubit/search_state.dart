part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<SearchResult> searchResult;
  final TextEditingController searchController;

  const SearchState(
      {required this.searchResult, required this.searchController});

  static SearchState empty = SearchState(
    searchController: TextEditingController(),
    searchResult: const [],
  );

  SearchState copyWith({
    List<SearchResult>? searchResult,
    TextEditingController? searchController,
  }) {
    return SearchState(
      searchResult: searchResult ?? this.searchResult,
      searchController: searchController ?? this.searchController,
    );
  }

  @override
  List<Object> get props => [searchController, searchResult];
}
