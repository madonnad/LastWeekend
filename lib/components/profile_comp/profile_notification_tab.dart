import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/album_invite_notification_comp.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/basic_notification_comp.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/friend_request_notification_comp.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/summary_notification_comp.dart';
import 'package:shared_photo/models/notification.dart';

class ProfileNotificationTab extends StatelessWidget {
  const ProfileNotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(
          const LoadNotifications(index: 0, location: LoadLocation.init),
        );
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 15.5),
          child: ListView.builder(
            itemCount: state.myNotifications.length,
            itemBuilder: (context, index) {
              context.read<ProfileBloc>().add(
                    LoadNotifications(
                      index: index,
                      location: LoadLocation.list,
                    ),
                  );

              //print(state.myNotifications.length);

              var type = state.myNotifications[index];

              if (type is AlbumInviteNotification) {
                return AlbumInviteNotificationComp(
                  index: index,
                );
              }
              if (type is FriendRequestNotification) {
                return FriendRequestNotificationComp(
                  index: index,
                );
              }
              if (type is SummaryNotification) {
                return SummaryNotificationComp(
                  index: index,
                  notificationDetailString: 'summary',
                );
              }
              if (type is GenericNotification) {
                switch (type.notificationType) {
                  case GenericNotificationType.likedPhoto:
                    return BasicNotificationComp(
                      index: index,
                      notificationDetailString: 'liked your photo',
                    );
                  case GenericNotificationType.upvotePhoto:
                    return BasicNotificationComp(
                      index: index,
                      notificationDetailString: 'upvoted your photo',
                    );
                  case GenericNotificationType.imageComment:
                    return BasicNotificationComp(
                      index: index,
                      notificationDetailString: 'commented',
                    );
                }
              }
            },
          ),
        );
      },
    );
  }
}
