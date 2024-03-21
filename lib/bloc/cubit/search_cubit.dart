import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GoRepository goRepository;

  SearchCubit({
    required this.goRepository,
  }) : super(SearchState.empty);

  Future<void> querySearch() async {
    List<SearchResult> resultList = [];

    emit(state.copyWith(isLoading: true));

    await Future.delayed(
      const Duration(milliseconds: 250),
      () async {
        resultList = await goRepository.searchLookup(
            lookup: state.searchController.text);
      },
    );

    emit(state.copyWith(searchResult: resultList, isLoading: false));
  }
}
