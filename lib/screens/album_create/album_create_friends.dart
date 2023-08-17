import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/album_create_comp/add_friends_list_item.dart';

class AlbumCreateFriends extends StatelessWidget {
  final PageController createAlbumController;
  const AlbumCreateFriends({super.key, required this.createAlbumController});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        children: [
          CustomScrollView(
            reverse: true,
            slivers: [
              SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: (state.friendsList != null)
                              ? devHeight * .25
                              : devHeight * .18,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60, left: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      splashColor: Colors.purple,
                                      onPressed: () =>
                                          createAlbumController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      ),
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.black45,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: (state.friendsList != null)
                                      ? const EdgeInsets.symmetric(vertical: 10)
                                      : EdgeInsets.zero,
                                ),
                                (state.friendsList != null)
                                    ? Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: state.friendsList!.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const CircleAvatar(),
                                                Text('First $index'),
                                              ],
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                            );
                                          },
                                        ),
                                      )
                                    : Text(
                                        'add friends',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                      builder: (context, state) {
                        return Expanded(
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: (state.friendsList != null)
                                ? state.friendsList!.length
                                : context
                                    .read<AppBloc>()
                                    .state
                                    .user
                                    .friendsList!
                                    .length,
                            itemBuilder: (context, index) {
                              return AddFriendsListItem(
                                  name: 'Zoe ${index + 1}');
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: 'search friends',
                            hintStyle: GoogleFonts.poppins()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
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
