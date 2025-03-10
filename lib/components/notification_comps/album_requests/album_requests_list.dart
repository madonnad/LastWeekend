import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/album_requests/album_request_accepted_item.dart';
import 'package:shared_photo/components/notification_comps/album_requests/album_request_item.dart';
import 'package:shared_photo/components/notification_comps/empty_lists/empty_list_comp.dart';
import 'package:shared_photo/models/notification.dart';

class AlbumRequestsList extends StatelessWidget {
  const AlbumRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.unseenFriendRequests) {
          context.read<NotificationCubit>().markListAsRead(1);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: state.albumInviteList.length,
                itemBuilder: (context, index) {
                  switch (state.albumInviteList[index].status) {
                    case RequestStatus.pending:
                      return AlbumRequestItem(
                        profileImage: state.albumInviteList[index].ownerURL,
                        albumCover: state.albumInviteList[index].imageReq,
                        firstName: state.albumInviteList[index].ownerFirst,
                        albumName: state.albumInviteList[index].albumName,
                        requestID: state.albumInviteList[index].notificationID,
                      );
                    case RequestStatus.accepted:
                      return AlbumRequestAcceptedItem(
                        profileImage: state.albumInviteList[index].ownerURL,
                        albumCover: state.albumInviteList[index].imageReq,
                        firstName: state.albumInviteList[index].ownerFirst,
                        albumName: state.albumInviteList[index].albumName,
                        requestID: state.albumInviteList[index].notificationID,
                        timeUntil: state.albumInviteList[index].timeUntil,
                      );
                    case RequestStatus.denied:
                      return const SizedBox(height: 0);
                    case RequestStatus.abandoned:
                      return const SizedBox(height: 0);
                  }
                },
              ),
              (state.albumInviteList.any(
                      (request) => request.status == RequestStatus.pending))
                  ? const SliverToBoxAdapter(child: SizedBox(height: 0))
                  : const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyListComponent(listName: "Album Invite")),
            ],
          ),
        );
      },
    );
  }
}
