import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/all_notifications/accepted_album_item.dart';
import 'package:shared_photo/components/notification_comps/empty_lists/empty_list_comp.dart';
import 'package:shared_photo/models/notification.dart';

class AllNotisList extends StatelessWidget {
  const AllNotisList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.unseenGenericNoti) {
          context.read<NotificationCubit>().markListAsRead(0);
        }
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: state.allNotifications.length,
                itemBuilder: (context, index) {
                  switch (state.allNotifications[index].runtimeType) {
                    case AlbumInviteResponseNotification:
                      AlbumInviteResponseNotification response =
                          state.allNotifications[index]
                              as AlbumInviteResponseNotification;
                      return AcceptedAlbumItem(
                        profileImage: response.senderURL,
                        firstName: response.guestFirst,
                        albumName: response.albumName,
                        timeSince: response.timeReceived,
                      );
                    default:
                      return Container(
                        height: 70,
                        width: 100,
                        color: Colors.yellow,
                      );
                  }
                },
              ),
              (state.allNotifications.isNotEmpty)
                  ? const SliverToBoxAdapter(child: SizedBox(height: 0))
                  : const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyListComponent(listName: "Notification"),
                    ),
            ],
          ),
        );
      },
    );
  }
}
