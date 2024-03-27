import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';
import 'package:shared_photo/models/friend.dart';

class FriendsAlbumSection extends StatelessWidget {
  const FriendsAlbumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendProfileCubit, FriendProfileState>(
      builder: (context, state) {
        switch (state.anonymousFriend.friendStatus) {
          case FriendStatus.notFriends || FriendStatus.pending:
            if (state.publicVisAlbumList.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeaderSmall("Zoe's Public Albums"),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: state.publicVisAlbumList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ListAlbumComponent(
                              album: state.publicVisAlbumList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox(height: 0);
            }
          case FriendStatus.friends:
            if (state.pubAndFriendVizAlbumsNotJoint.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeaderSmall("Zoe's Albums"),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: state.pubAndFriendVizAlbumsNotJoint.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ListAlbumComponent(
                              album:
                                  state.pubAndFriendVizAlbumsNotJoint[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox(height: 0);
            }
        }
      },
    );
  }
}
