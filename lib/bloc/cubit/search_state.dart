part of 'search_cubit.dart';

class SearchState extends Equatable {
  final List<SearchResult> searchResult;
  final TextEditingController searchController;
  final bool isLoading;

  const SearchState(
      {required this.searchResult,
      required this.searchController,
      required this.isLoading});

  static SearchState empty = SearchState(
    searchController: TextEditingController(),
    searchResult: const [],
    isLoading: false,
  );

  SearchState copyWith({
    List<SearchResult>? searchResult,
    TextEditingController? searchController,
    bool? isLoading,
  }) {
    return SearchState(
        searchResult: searchResult ?? this.searchResult,
        searchController: searchController ?? this.searchController,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [searchController, searchResult, isLoading];
}
