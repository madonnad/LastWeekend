import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_friend_comp/empty_friends_listview.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_friend_comp/search_results_listview.dart';
import 'package:shared_photo/components/new_create_album_comp/create_album_info_comp/added_friends_listview.dart';

class CreateFriendAddPage extends StatelessWidget {
  final PageController pageController;
  const CreateFriendAddPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: kToolbarHeight,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.linear,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
            builder: (context, state) {
              return TextField(
                controller: state.friendSearch,
                onTapOutside: (_) {
                  //FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (_) =>
                    context.read<CreateAlbumCubit>().searchFriendByName(),
                style: GoogleFonts.josefinSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Search Friends",
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
              );
            },
          ),
          BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
            builder: (context, state) {
              if (state.invitedFriends.isNotEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: AddedFriendsListView(),
                );
              } else {
                return SizedBox(height: 0);
              }
            },
          ),
          Expanded(
            child: BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
              builder: (context, state) {
                switch (state.friendState) {
                  case FriendState.searching:
                    return const SearchResultsListView();
                  case FriendState.empty:
                    return const EmptyFriendsListView();
                  default:
                    return const Text(
                      "Something broke :(",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
