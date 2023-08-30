import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/album_invite_notification_comp.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/basic_notification_comp.dart';
import 'package:shared_photo/components/profile_comp/notification_comp/friend_request_notification_comp.dart';
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
        return ListView.builder(
          itemCount: state.myNotifications.length,
          itemBuilder: (context, index) {
            context.read<ProfileBloc>().add(
                  LoadNotifications(
                    index: index,
                    location: LoadLocation.list,
                  ),
                );

            var type = state.myNotifications[index];
            if (type is AlbumInviteNotification) {
              return Center(
                child: AlbumInviteNotificationComp(
                  index: index,
                ),
              );
            }
            if (type is FriendRequestNotification) {
              return const Center(
                child: FriendRequestNotificationComp(),
              );
            }
            if (type is GenericNotification) {
              switch (type) {
                case GenericNotificationType.likedPhoto:
                  return const Center(
                    child: BasicNotificationComp(),
                  );
                case GenericNotificationType.upvotePhoto:
                  return const Center(
                    child: BasicNotificationComp(),
                  );
                case GenericNotificationType.imageComment:
                  return const Center(
                    child: BasicNotificationComp(),
                  );
              }
            }
          },
        );
      },
    );
  }
}
