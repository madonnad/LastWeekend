import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class AddedFriendsListView extends StatelessWidget {
  const AddedFriendsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.invitedFriends.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 44, 44, 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 20,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.invitedFriends[index].firstName,
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context
                            .read<CreateAlbumCubit>()
                            .handleFriendAddRemoveFromAlbum(
                                state.invitedFriends[index]),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.cancel,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 5,
            ),
          ),
        );
      },
    );
  }
}
