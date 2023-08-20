import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/album_create_comp/add_friends_list_item.dart';

class FriendSearchSection extends StatelessWidget {
  const FriendSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: state.searchResult.length,
            itemBuilder: (context, index) {
              return AddFriendsListItem(
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
