import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/search_result.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState.empty);

  Future<void> querySearch() async {
    List<SearchResult> resultList = [];

    emit(state.copyWith(searchResult: resultList));
  }
}
