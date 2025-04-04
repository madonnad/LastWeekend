import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/components/new_search_comp/user_search_result.dart';
import 'package:shared_photo/models/search_result.dart';

class SearchFrame extends StatefulWidget {
  const SearchFrame({super.key});

  @override
  State<SearchFrame> createState() => _SearchFrameState();
}

class _SearchFrameState extends State<SearchFrame>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
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
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54,
                    ),
                    fillColor: Color.fromRGBO(34, 34, 38, 1),
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
                                    if (state.searchResult[index].id ==
                                        context.read<AppBloc>().state.user.id) {
                                      return GestureDetector(
                                        onTap: () => context
                                            .read<AppFrameCubit>()
                                            .changePage(4),
                                        child: UserSearchResult(
                                          result: state.searchResult[index],
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          FirebaseAnalytics.instance.logEvent(
                                            name: "clicked_friend_page",
                                            parameters: {
                                              "user_id":
                                                  state.searchResult[index].id
                                            },
                                          );
                                          Navigator.of(context).pushNamed(
                                            '/friend',
                                            arguments:
                                                state.searchResult[index].id,
                                          );
                                        },
                                        child: UserSearchResult(
                                          result: state.searchResult[index],
                                        ),
                                      );
                                    }
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
                              style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "🕵️",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 40,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
