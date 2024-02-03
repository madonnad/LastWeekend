import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GoRepository goRepository;
  final AppBloc appBloc;

  SearchCubit({
    required this.goRepository,
    required this.appBloc,
  }) : super(SearchState.empty);

  Future<void> querySearch(String lookup) async {
    String token = appBloc.state.user.token;
    List<SearchResult> resultList = [];

    emit(state.copyWith(isLoading: true));

    await Future.delayed(
      const Duration(seconds: 1),
      () async {
        resultList =
            await goRepository.searchLookup(lookup: lookup);
      },
    );

    emit(state.copyWith(searchResult: resultList, isLoading: false));
  }
}
