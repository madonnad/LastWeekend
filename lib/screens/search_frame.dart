import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/components/new_search_comp/user_search_result.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/repositories/go_repository.dart';

class SearchFrame extends StatelessWidget {
  const SearchFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        goRepository: context.read<GoRepository>(),
      ),
      child: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Column(
                children: [
                  TextField(
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onSubmitted: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onChanged: (value) =>
                        context.read<SearchCubit>().querySearch(),
                    controller: state.searchController,
                    style: GoogleFonts.josefinSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: GoogleFonts.josefinSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                      fillColor: const Color.fromRGBO(19, 19, 19, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  state.searchController.text.isNotEmpty
                      ? Expanded(
                          child: state.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  itemCount: state.searchResult.length,
                                  itemBuilder: ((context, index) {
                                    if (state.searchResult[index].resultType ==
                                        ResultType.user) {
                                      return UserSearchResult(
                                        result: state.searchResult[index],
                                      );
                                    } else {
                                      return const SizedBox(height: 0);
                                    }
                                  }),
                                ),
                        )
                      : Expanded(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Find your friends here!",
                                style: GoogleFonts.josefinSans(
                                    color: Colors.white.withOpacity(.8),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "🕵️",
                                style: GoogleFonts.josefinSans(
                                  color: Colors.white,
                                  fontSize: 60,
                                ),
                              ),
                            ),
                          ],
                        )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
