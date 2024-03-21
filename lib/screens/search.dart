import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/components/search_comp/search_album_comp.dart';
import 'package:shared_photo/components/search_comp/search_bar_comp.dart';
import 'package:shared_photo/components/search_comp/search_user_comp.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/repositories/go_repository.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        goRepository: context.read<GoRepository>(),
      ),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: state.isLoading == false
                      ? state.searchController.text == ""
                          ? Center(
                              child: Text(
                                "Search for Friends and Albums",
                                style: GoogleFonts.poppins(
                                    color: Colors.black45, fontSize: 20),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView.separated(
                                reverse: true,
                                itemCount: state.searchResult.length,
                                itemBuilder: (context, index) {
                                  switch (
                                      state.searchResult[index].resultType) {
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
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    bottom:
                        (MediaQuery.of(context).viewInsets.bottom * .70) + 8,
                    top: 10,
                  ),
                  child: const SearchBarComponent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
