import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/components/search_comp/search_album_comp.dart';
import 'package:shared_photo/components/search_comp/search_bar_comp.dart';
import 'package:shared_photo/components/search_comp/search_user_comp.dart';
import 'package:shared_photo/models/search_result.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.separated(
                    reverse: true,
                    itemCount: state.searchResult.length,
                    itemBuilder: (context, index) {
                      switch (state.searchResult[index].resultType) {
                        case ResultType.user:
                          return SearchUserComponent(index: index);
                        case ResultType.album:
                          return SearchAlbumComponent(index: index);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 4);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  bottom: (MediaQuery.of(context).viewInsets.bottom * .70),
                  top: 10,
                ),
                child: const SearchBarComponent(),
              ),
            ],
          ),
        );
      },
    );
  }
}
