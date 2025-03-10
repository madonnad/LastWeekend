import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/empty_lists/empty_list_comp.dart';
import 'package:shared_photo/components/notification_comps/friend_requests/friend_request_accepted_item.dart';
import 'package:shared_photo/components/notification_comps/friend_requests/friend_request_item.dart';
import 'package:shared_photo/models/notification.dart';

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.unseenFriendRequests) {
          context.read<NotificationCubit>().markListAsRead(2);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.friendRequestList.length,
                  itemBuilder: (context, index) {
                    switch (state.friendRequestList[index].status) {
                      case RequestStatus.accepted:
                        bool userIsSender =
                            state.friendRequestList[index].senderID ==
                                context.read<AppBloc>().state.user.id;
                        String profileImage = userIsSender
                            ? state.friendRequestList[index].receiverReq
                            : state.friendRequestList[index].senderReq;
                        String userID = userIsSender
                            ? state.friendRequestList[index].receiverID
                            : state.friendRequestList[index].senderID;
                        return FriendRequestAcceptedItem(
                          firstName: state.friendRequestList[index].firstName,
                          profileImage: profileImage,
                          userID: userID,
                        );
                      case RequestStatus.pending:
                        return FriendRequestItem(
                          firstName: state.friendRequestList[index].firstName,
                          lastName: state.friendRequestList[index].lastName,
                          profileImage: state.friendRequestList[index].imageReq,
                          senderID: state.friendRequestList[index].senderID,
                          requestID:
                              state.friendRequestList[index].notificationID,
                        );

                      case RequestStatus.denied:
                        return const SizedBox(height: 0);
                      case RequestStatus.abandoned:
                        return const SizedBox(height: 0);
                    }
                  },
                ),
              ),
              (state.friendRequestList.any(
                      (request) => request.status == RequestStatus.pending))
                  ? const SizedBox(height: 0)
                  : const Expanded(
                      flex: 10,
                      child: EmptyListComponent(listName: "Friend Request"),
                    )
            ],
          ),
        );
      },
    );
  }
}
