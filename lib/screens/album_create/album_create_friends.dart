import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/album_create_comp/add_friends_list_item.dart';
import 'package:shared_photo/components/album_create_comp/added_friends_header.dart';
import 'package:shared_photo/components/album_create_comp/empty_friends_section.dart';
import 'package:shared_photo/components/album_create_comp/friends_no_search_section.dart';
import 'package:shared_photo/components/album_create_comp/friends_search_section.dart';
import 'package:shared_photo/components/album_create_comp/modal_header.dart';

class AlbumCreateFriends extends StatelessWidget {
  final PageController createAlbumController;
  const AlbumCreateFriends({super.key, required this.createAlbumController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            reverse: true,
            slivers: [
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: ModalHeader(
                        iconFunction: () => createAlbumController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                        title: 'add friends',
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black45,
                          size: 30,
                        ),
                      ),
                    ),
                    const AddedFriendsHeader(),
                    BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                      builder: (context, state) {
                        switch (state.friendState) {
                          case FriendState.empty:
                            return const EmptyFriendsSection();
                          case FriendState.added:
                            return const FriendsNoSearchSection();
                          case FriendState.searching:
                            return const FriendSearchSection();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                        builder: (context, state) {
                          return TextField(
                            controller: state.friendSearch,
                            onTapOutside: (_) => context
                                .read<CreateAlbumCubit>()
                                .checkToShowState(),
                            onChanged: (value) {
                              context
                                  .read<CreateAlbumCubit>()
                                  .searchFriendByName();
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'search friends',
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                    BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.canCreate
                              ? () =>
                                  context.read<CreateAlbumCubit>().createAlbum()
                              : null,
                          child: const Text('Create Album'),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Page 2'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
