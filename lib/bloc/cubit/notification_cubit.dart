import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';
import 'package:shared_photo/services/engagement_service.dart';
import 'package:shared_photo/services/request_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  User user;
  NotificationRepository notificationRepository;

  NotificationCubit({
    required this.notificationRepository,
    required this.user,
  }) : super(const NotificationState()) {
    // Synchronize with Repository
    _initalizeNotifications();

    // Listen to Repository
    notificationRepository.notificationStream.listen((event) {
      StreamOperation operation = event.$1;
      Notification notification = event.$2;

      switch (notification.runtimeType) {
        case FriendRequestNotification:
          _friendRequestHandler(
              operation, notification as FriendRequestNotification);
        case AlbumInviteNotification:
          _albumInviteHandler(
              operation, notification as AlbumInviteNotification);
        case ConsolidatedNotification:
          _engagementHandler(
              operation, notification as ConsolidatedNotification);
        case CommentNotification:
          _commentHandler(operation, notification as CommentNotification);
      }
    });
  }

  void markListAsRead(int index) {
    switch (index) {
      case 0:
        for (Notification notification in state.allNotifications) {
          switch (notification.runtimeType) {
            case AlbumInviteNotification:
              notification as AlbumInviteNotification;
              if (notification.notificationSeen == false ||
                  notification.responseSeen == false) {
                RequestService.markAlbumInviteResponsetAsSeen(
                    user.token, notification.notificationID);
              }
            case ConsolidatedNotification:
              notification as ConsolidatedNotification;
              for (EngagementNotification noti
                  in notification.notificationMap.values) {
                if (noti.notificationSeen == false) {
                  EngagementService.markNotificationSeen(
                      user.token, noti.notificationID);
                }
              }
            case CommentNotification:
              if (notification.notificationSeen == false) {
                notification as CommentNotification;
                EngagementService.markCommentSeen(
                    user.token, notification.notificationID);
              }
          }
        }
        emit(state.copyWith(unseenGenericNoti: false));
        return;
      case 1:
        emit(state.copyWith(unseenAlbumInvites: false));
        return;
      case 2:
        for (FriendRequestNotification request in state.friendRequestList) {
          if (request.notificationSeen == false) {
            notificationRepository
                .markFriendRequestSeen(request.notificationID);
          }
        }
        emit(state.copyWith(unseenFriendRequests: false));
        return;
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  // Friend Request Functions
  Future<bool> acceptFriendRequest(
      {required String requestID, required String senderID}) async {
    bool success =
        await notificationRepository.acceptFriendRequest(requestID, senderID);

    if (success) {
      return true;
    } else {
      emit(state.copyWith(exception: "Failed to accept friend request"));
      emit(state.copyWith(exception: ""));
      return false;
    }
  }

  Future<bool> denyFriendRequest(String requestID) async {
    bool success = await notificationRepository.denyFriendRequest(requestID);

    if (success) {
      return true;
    } else {
      emit(state.copyWith(exception: "Failed to deny friend request"));
      emit(state.copyWith(exception: ""));
      return false;
    }
  }

// Album Invite Functions
  Future<bool> acceptAlbumInvite({required String requestID}) async {
    bool success = await notificationRepository.acceptAlbumInvite(requestID);

    if (success) {
      return true;
    } else {
      emit(state.copyWith(exception: "Failed to accept friend request"));
      emit(state.copyWith(exception: ""));
      return false;
    }
  }

  Future<bool> denyAlbumInvite({required String requestID}) async {
    bool success = await notificationRepository.denyAlbumInvite(requestID);

    if (success) {
      return true;
    } else {
      emit(state.copyWith(exception: "Failed to accept friend request"));
      emit(state.copyWith(exception: ""));
      return false;
    }
  }

  void clearTempNotifications() {
    if (!state.unseenFriendRequests) {
      _clearFriendRequestAccepted();
    }
    if (!state.unseenAlbumInvites) {}
  }

  // Private Functions
  Future<void> _initalizeNotifications() async {
    Map<String, FriendRequestNotification> friendRequestMap =
        notificationRepository.friendRequestMap;
    Map<String, AlbumInviteNotification> albumInviteMap =
        notificationRepository.albumInviteMap;
    Map<String, Notification> allNotificationMap =
        notificationRepository.allNotificationMap;

    bool friendRequestUnseen = friendRequestMap.values
        .any((element) => element.notificationSeen == false);

    bool albumInviteUnseen = albumInviteMap.values.any((element) =>
        (element.status == RequestStatus.pending &&
            element.notificationSeen == false));

    bool allNotificationsUnseen = allNotificationMap.values
        .any((element) => element.notificationSeen == false);

    emit(
      state.copyWith(
        friendRequestMap: friendRequestMap,
        albumInviteMap: albumInviteMap,
        allNotificationMap: allNotificationMap,
        unseenFriendRequests: friendRequestUnseen,
        unseenAlbumInvites: albumInviteUnseen,
        unseenGenericNoti: allNotificationsUnseen,
      ),
    );
  }

  void _clearFriendRequestAccepted() {
    for (FriendRequestNotification request in state.friendRequestMap.values) {
      if (request.status == RequestStatus.accepted &&
          request.notificationSeen) {
        bool canDelete = false;
        if (user.id == request.senderID) {
          canDelete = true;
        }
        notificationRepository.removeFriendRequestAccepted(
          canDelete,
          request.notificationID,
        );
      }
    }
  }

  void _friendRequestHandler(
      StreamOperation operation, FriendRequestNotification request) {
    Map<String, FriendRequestNotification> friendRequestCopy =
        Map.from(state.friendRequestMap);

    switch (request.status) {
      case RequestStatus.pending:
        friendRequestCopy[request.notificationID] = request;

        emit(state.copyWith(
          friendRequestMap: friendRequestCopy,
          unseenFriendRequests: !request.notificationSeen,
        ));

      case RequestStatus.accepted:
        switch (operation) {
          case StreamOperation.add:
            friendRequestCopy[request.notificationID] = request;
            emit(state.copyWith(
              friendRequestMap: friendRequestCopy,
              unseenFriendRequests: true,
            ));
          case StreamOperation.delete:
            friendRequestCopy
                .removeWhere((key, value) => key == request.notificationID);
            emit(state.copyWith(
              friendRequestMap: friendRequestCopy,
              unseenFriendRequests: false,
            ));
          case StreamOperation.update:
            friendRequestCopy[request.notificationID] = request;
            emit(state.copyWith(
              friendRequestMap: friendRequestCopy,
              unseenFriendRequests: true,
            ));
        }
      case RequestStatus.denied:
        friendRequestCopy
            .removeWhere((key, value) => key == request.notificationID);
        emit(state.copyWith(
          friendRequestMap: friendRequestCopy,
          unseenFriendRequests: false,
        ));
        return;
    }
  }

  void _albumInviteHandler(
      StreamOperation operation, AlbumInviteNotification invite) {
    switch (invite.status) {
      // Manages the UI of the notifications - filtered for the those that need
      // to see certain information.
      case RequestStatus.pending:
        Map<String, AlbumInviteNotification> albumInviteCopy =
            Map.from(state.albumInviteMap);
        albumInviteCopy[invite.notificationID] = invite;
        emit(
          state.copyWith(
            albumInviteMap: albumInviteCopy,
            unseenAlbumInvites: !invite.notificationSeen,
          ),
        );

      case RequestStatus.accepted:
        // Sends the update to the owner of the album
        // that someone has accepted the invite
        if (user.id == invite.albumOwner) {
          Map<String, Notification> allNotiCopy =
              Map.from(state.allNotificationMap);
          allNotiCopy.putIfAbsent(invite.notificationID, () => invite);
          emit(
            state.copyWith(
              allNotificationMap: allNotiCopy,
              unseenGenericNoti: !invite.responseSeen,
            ),
          );
        }
        // Sends the update to the guest of the album
        // that they have accepted
        if (user.id == invite.guestID) {
          Map<String, AlbumInviteNotification> albumInviteCopy =
              Map.from(state.albumInviteMap);
          albumInviteCopy.update(
            invite.notificationID,
            (value) => value.copyWith(status: RequestStatus.accepted),
          );
          emit(
            state.copyWith(
              albumInviteMap: albumInviteCopy,
              unseenAlbumInvites: !invite.notificationSeen,
            ),
          );
        }
      case RequestStatus.denied:
        Map<String, AlbumInviteNotification> albumInviteCopy =
            Map.from(state.albumInviteMap);
        albumInviteCopy
            .removeWhere((key, value) => key == invite.notificationID);
        emit(
          state.copyWith(
            albumInviteMap: albumInviteCopy,
            unseenAlbumInvites: false,
          ),
        );
    }
  }

  void _engagementHandler(
      StreamOperation operation, ConsolidatedNotification notification) {
    switch (operation) {
      case StreamOperation.add:
        bool unseenNoti = notification.notificationMap.values
            .any((element) => element.notificationSeen == false);

        Map<String, Notification> notiMap = Map.from(state.allNotificationMap);
        notiMap.update(
          notification.mapKey,
          (value) => notification,
          ifAbsent: () => notification,
        );

        emit(state.copyWith(
          allNotificationMap: notiMap,
          unseenGenericNoti: unseenNoti,
        ));

      case StreamOperation.update:
      // TODO: Handle this case.
      case StreamOperation.delete:
      // TODO: Handle this case.
    }
  }

  void _commentHandler(
      StreamOperation operation, CommentNotification notification) {
    switch (operation) {
      case StreamOperation.add:
        Map<String, Notification> notiMap = Map.from(state.allNotificationMap);
        bool commentSeen = !notification.notificationSeen;

        notiMap.update(
          notification.notificationID,
          (value) => notification,
          ifAbsent: () => notification,
        );

        emit(state.copyWith(
          allNotificationMap: notiMap,
          unseenGenericNoti: commentSeen,
        ));

      case StreamOperation.update:
      // TODO: Handle this case.
      case StreamOperation.delete:
      // TODO: Handle this case.
    }
  }
}
