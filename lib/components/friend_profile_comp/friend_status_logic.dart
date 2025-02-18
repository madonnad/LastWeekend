import 'package:firebase_analytics/firebase_analytics.dart';
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
                backgroundColor: state.friendStatusLoading
                    ? const Color.fromRGBO(255, 98, 96, .5)
                    : const Color.fromRGBO(255, 98, 96, 1),
                textColor: Color.fromRGBO(242, 243, 247, 1),
                borderColor: Colors.transparent,
                onTap: () {
                  context.read<FriendProfileCubit>().sendFriendRequest();
                  FirebaseAnalytics.instance.logEvent(
                      name: "friend_request_sent",
                      parameters: {"friend_id": state.anonymousFriend.uid});
                });
          case FriendStatus.friends:
            return FriendStatusButton(
              text: "Friends",
              backgroundColor: state.friendStatusLoading
                  ? const Color.fromRGBO(19, 19, 19, .5)
                  : const Color.fromRGBO(19, 19, 19, 1),
              textColor: const Color.fromRGBO(255, 98, 96, 1),
              borderColor: const Color.fromRGBO(255, 98, 96, 1),
              onTap: () {},
            );
          case FriendStatus.pending:
            return FriendStatusButton(
              text: "Pending",
              backgroundColor: state.friendStatusLoading
                  ? const Color.fromRGBO(255, 98, 96, .25)
                  : const Color.fromRGBO(255, 98, 96, .5),
              textColor: Color.fromRGBO(242, 243, 247, .5),
              borderColor: Colors.transparent,
              onTap: () {},
            );
        }
      },
    );
  }
}
