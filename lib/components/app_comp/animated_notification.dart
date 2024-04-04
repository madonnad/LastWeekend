import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/notification.dart';

class AnimatedNotification extends StatefulWidget {
  const AnimatedNotification({super.key});

  @override
  State<AnimatedNotification> createState() => _AnimatedNotificationState();
}

class _AnimatedNotificationState extends State<AnimatedNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 2.5),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
          previous.myNotifications.length < current.myNotifications.length,
      builder: (context, state) {
        var type = state.myNotifications[0];

        if (type is AlbumInviteNotification) {
          return SlideTransition(
            position: _offsetAnimation,
            child: const Icon(
              Icons.collections,
              color: Colors.cyan,
            ),
          );
        }
        if (type is FriendRequestNotification) {
          return SlideTransition(
            position: _offsetAnimation,
            child: const Icon(
              Icons.people,
              color: Colors.deepPurple,
            ),
          );
        }
        // if (type is GenericNotification) {
        //   switch (type.notificationType) {
        //     case GenericNotificationType.likedPhoto:
        //       return SlideTransition(
        //         position: _offsetAnimation,
        //         child: const Icon(
        //           Icons.favorite,
        //           color: Colors.red,
        //         ),
        //       );
        //     case GenericNotificationType.upvotePhoto:
        //       return SlideTransition(
        //         position: _offsetAnimation,
        //         child: const Icon(
        //           Icons.arrow_circle_up,
        //           color: Colors.deepPurple,
        //         ),
        //       );
        //     case GenericNotificationType.imageComment:
        //       return SlideTransition(
        //         position: _offsetAnimation,
        //         child: const Icon(
        //           Icons.comment,
        //           color: Colors.deepPurple,
        //         ),
        //       );
        //   }
        // }
        return SizedBox.shrink();
      },
    );
  }
}

/*class AlbumCover extends StatelessWidget {
  const AlbumCover({super.key});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;
    var height = AppBar().preferredSize.height - 25;
    print(height);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String notificationUrl =
            state.myNotifications[0].notificationMediaURL ?? '';
        return Card(
          elevation: 4,
          shadowColor: const Color.fromRGBO(0, 0, 41, .25),
          clipBehavior: Clip.hardEdge,
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: height,
            height: height,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: (state.isLoading == false && notificationUrl != '')
                ? Image.network(
                    notificationUrl,
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}*/
