import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/friend_requests/friend_request_item.dart';

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: ListView.builder(
            itemCount: state.friendRequestList.length,
            itemBuilder: (context, index) {
              return FriendRequestItem(
                firstName: state.friendRequestList[index].firstName,
                lastName: state.friendRequestList[index].lastName,
                profileImage: state.friendRequestList[index].imageReq,
                requesterID: state.friendRequestList[index].notificationID,
              );
            },
          ),
        );
      },
    );
  }
}
