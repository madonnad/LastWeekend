import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/notification_comps/all_notifications/accepted_album_item.dart';
import 'package:shared_photo/components/notification_comps/all_notifications/comment_noti_item.dart';
import 'package:shared_photo/components/notification_comps/all_notifications/engagement_noti_comp.dart';
import 'package:shared_photo/components/notification_comps/empty_lists/empty_list_comp.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/utils/day_seperator.dart';

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
              SliverList.separated(
                itemCount: state.allNotifications.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return const SizedBox(height: 0);
                  int adjIndex = index - 1;
                  switch (state.allNotifications[adjIndex].runtimeType) {
                    case AlbumInviteNotification:
                      AlbumInviteNotification response =
                          state.allNotifications[adjIndex]
                              as AlbumInviteNotification;
                      return AcceptedAlbumItem(
                        albumID: response.albumID,
                        profileImage: response.guestURL,
                        firstName: response.guestFirst,
                        albumName: response.albumName,
                        timeSince: response.timeReceived,
                      );
                    case ConsolidatedNotification:
                      ConsolidatedNotification notification =
                          state.allNotifications[adjIndex]
                              as ConsolidatedNotification;
                      return EngagementNotiComp(notification: notification);
                    case CommentNotification:
                      CommentNotification notification = state
                          .allNotifications[adjIndex] as CommentNotification;
                      return CommentNotiItem(notification: notification);
                    default:
                      return Container(
                        height: 70,
                        width: 100,
                        color: const Color.fromRGBO(44, 44, 44, 1),
                      );
                  }
                },
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    String headerText = DaySeperator.dayItem(
                        state.allNotifications[index].receivedDateTime);
                    return SectionHeaderSmall(headerText);
                  } else {
                    String previousString = DaySeperator.dayItem(
                        state.allNotifications[index - 1].receivedDateTime);
                    String currentString = DaySeperator.dayItem(
                        state.allNotifications[index].receivedDateTime);

                    if (previousString != currentString) {
                      return SectionHeaderSmall(currentString);
                    }
                  }
                  return const SizedBox(height: 0);
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
