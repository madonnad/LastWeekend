import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_status_button.dart';
import 'package:shared_photo/models/friend.dart';

class FriendStatusLogic extends StatelessWidget {
  const FriendStatusLogic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendProfileCubit, FriendProfileState>(
      builder: (context, state) {
        switch (state.anonymousFriend.friendStatus) {
          case FriendStatus.notFriends:
            return FriendStatusButton(
              text: "Add Friend",
              backgroundColor: const Color.fromRGBO(181, 131, 141, 1),
              textColor: Colors.black,
              borderColor: Colors.transparent,
              onTap: () {},
            );
          case FriendStatus.friends:
            return FriendStatusButton(
              text: "Friends",
              backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
              textColor: const Color.fromRGBO(181, 131, 141, 1),
              borderColor: const Color.fromRGBO(181, 131, 141, 1),
              onTap: () {},
            );
          case FriendStatus.pending:
            return FriendStatusButton(
              text: "Pending",
              backgroundColor: const Color.fromRGBO(181, 131, 141, .5),
              textColor: Colors.black,
              borderColor: Colors.transparent,
              onTap: () {},
            );
        }
      },
    );
  }
}
