import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/search_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final User user;

  SearchCubit({
    required this.user,
  }) : super(SearchState.empty);

  void clearTextController() {
    emit(state.copyWith(searchController: TextEditingController()));
  }

  Future<void> querySearch() async {
    List<SearchResult> resultList = [];

    emit(state.copyWith(isLoading: true));

    await Future.delayed(
      const Duration(milliseconds: 250),
      () async {
        resultList = await SearchService.searchLookup(
          token: user.token,
          lookup: state.searchController.text,
        );
      },
    );

    emit(state.copyWith(searchResult: resultList, isLoading: false));
  }
}
