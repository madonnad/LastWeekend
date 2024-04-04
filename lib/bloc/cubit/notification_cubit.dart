import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';

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
        case AlbumInviteResponseNotification:
      }
    });
  }

  void markListAsRead(int index) {
    switch (index) {
      case 0:
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

    bool unseenFriendRequests = false;

    emit(
      state.copyWith(
        friendRequestMap: friendRequestMap,
        albumInviteMap: albumInviteMap,
        unseenFriendRequests: unseenFriendRequests,
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
}
