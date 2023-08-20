import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class AddFriendsListItem extends StatelessWidget {
  final int index;

  const AddFriendsListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35.0,
        vertical: 8,
      ),
      child: BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
        builder: (context, state) {
          String uid = state.searchResult[index].uid;
          bool isAdded = state.friendsList.any((element) => element.uid == uid);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                  ),
                  Text(
                    '${state.searchResult[index].firstName} ${state.searchResult[index].lastName}',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                child: isAdded
                    ? const Icon(Icons.remove)
                    : const Icon(
                        Icons.add,
                      ),
                onTap: () => context
                    .read<CreateAlbumCubit>()
                    .handleFriendAddRemoveFromAlbum(state.searchResult[index]),
              )
            ],
          );
        },
      ),
    );
  }
}
