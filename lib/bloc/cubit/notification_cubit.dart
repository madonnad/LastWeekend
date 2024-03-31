import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/services/notification_service.dart';
import 'package:shared_photo/services/request_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  User user;
  RealtimeRepository realtimeRepository;

  NotificationCubit({
    required this.realtimeRepository,
    required this.user,
  }) : super(const NotificationState()) {
    _initalizeNotifications();

    realtimeRepository.realtimeNotificationStream.listen((notification) {
      _notificationTypeHandler(notification);
    });
  }

  void _notificationTypeHandler(Notification notification) {
    switch (notification.runtimeType) {
      case FriendRequestNotification:
        _friendRequestHandler(notification as FriendRequestNotification);
      case AlbumInviteNotification:
      case GenericNotification:
    }
  }

  Future<bool> acceptFriendRequest(String friendID) async {
    Map<String, FriendRequestNotification> friendRequestCopy =
        Map.from(state.friendRequestMap);

    if (friendRequestCopy[friendID] != null) {
      bool success =
          await RequestService.acceptFriendRequest(user.token, friendID);

      if (success) {
        FriendRequestNotification acceptedRequest = friendRequestCopy[friendID]!
            .copyWith(status: FriendRequestStatus.accepted);

        friendRequestCopy[friendID] = acceptedRequest;
        emit(state.copyWith(friendRequestMap: friendRequestCopy));
        return true;
      } else {
        emit(state.copyWith(exception: "Failed to accept friend request"));
        emit(state.copyWith(exception: ""));
        return false;
      }
    }
    return false;
  }

  void clearTabNotifications(int index) {
    if (state.unreadNotificationTabs[index] == true) {
      List<bool> unreadNotificationTabs =
          List.from(state.unreadNotificationTabs);
      unreadNotificationTabs[index] = false;
      emit(state.copyWith(unreadNotificationTabs: unreadNotificationTabs));
    }
  }

  void clearAcceptedInvitesRequests() {
    Map<String, FriendRequestNotification> friendReqMap =
        Map.from(state.friendRequestMap);

    friendReqMap.removeWhere(
        (key, value) => value.status == FriendRequestStatus.accepted);
    emit(state.copyWith(friendRequestMap: friendReqMap));
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  // Private Functions

  Future<void> _initalizeNotifications() async {
    Map<String, FriendRequestNotification> friendRequestFetch = {};
    Map<String, AlbumInviteNotification> albumInviteFetch = {};
    Map<String, GenericNotification> genericNotificationFetch = {};

    List<Notification> allNotifications =
        await NotificationService().getNotifications(user.token);

    for (Notification notification in allNotifications) {
      switch (notification.runtimeType) {
        case FriendRequestNotification:
          // Cast to FriendRequestNotification
          FriendRequestNotification request =
              notification as FriendRequestNotification;
          // Add to the friendRequestFetch map
          friendRequestFetch.putIfAbsent(request.notificationID, () => request);
        case AlbumInviteNotification:
          // Cast to AlbumInviteNotification
          AlbumInviteNotification request =
              notification as AlbumInviteNotification;
          // Add to the albumInviteFetch map
          albumInviteFetch.putIfAbsent(request.notificationID, () => request);
        case GenericNotification:
          // Cast to GenericNotification
          GenericNotification request = notification as GenericNotification;
          // Add to the genericNotificationFetch map
          genericNotificationFetch.putIfAbsent(
              request.notificationID, () => request);
      }
    }
    emit(state.copyWith(
      friendRequestMap: friendRequestFetch,
      albumInviteMap: albumInviteFetch,
      genericNotificationMap: genericNotificationFetch,
    ));
  }

  void _friendRequestHandler(FriendRequestNotification request) {
    Map<String, FriendRequestNotification> friendRequestCopy =
        Map.from(state.friendRequestMap);

    switch (request.status) {
      case FriendRequestStatus.pending:
        friendRequestCopy.putIfAbsent(request.notificationID, () => request);
      case FriendRequestStatus.accepted:
        friendRequestCopy
            .removeWhere((key, value) => key == request.notificationID);

      case FriendRequestStatus.decline:
        friendRequestCopy
            .removeWhere((key, value) => key == request.notificationID);
    }

    emit(state.copyWith(
      friendRequestMap: friendRequestCopy,
      unreadNotificationTabs: [false, false, true],
    ));
  }
}
