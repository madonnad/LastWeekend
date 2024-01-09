import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppBloc appBloc;
  final GoRepository goRepository;

  ProfileBloc({required this.appBloc, required this.goRepository})
      : super(ProfileState.empty) {
    final String token = appBloc.state.user.token;

    on<InitializeProfile>(
      (event, emit) async {
        String token = appBloc.state.user.token;
        emit(state.copyWith(isLoading: true));

        goRepository.getImageComments(
            token, "c629661f-575b-4dd8-87f5-dde913ab764d");

        List<Album> myAlbums = await goRepository.getUsersAlbums(token);

        List<Notification> myNotifications =
            await goRepository.getNotifications(token);

        List<Image> myImages = await goRepository.getUserImages(token);

        List<Friend> myFriends = await goRepository.getFriendsList(token);

        emit(
          state.copyWith(
            myAlbums: myAlbums,
            myImages: myImages,
            myNotifications: myNotifications,
            myFriends: myFriends,
            isLoading: false,
          ),
        );
      },
    );

    on<FriendRequestEvent>((event, emit) async {
      List<Notification> myNotifications = [];
      myNotifications = List.from(state.myNotifications);

      if (event.action == RequestAction.accept) {
        // Accept Friend Request
        emit(state.copyWith(isLoading: true));

        try {
          List<Friend> myFriends = [];

          await goRepository.acceptFriendRequest(token, event.friendID);

          myNotifications.removeWhere(
              (element) => element.notificationID == event.friendID);
          myFriends = await goRepository.getFriendsList(token);

          emit(state.copyWith(
              isLoading: false,
              myNotifications: myNotifications,
              myFriends: myFriends));
        } catch (e) {
          //print(e.toString());
          emit(state.copyWith(isLoading: false, error: e.toString()));
        }
      } else if (event.action == RequestAction.deny) {
        // Deny Friend Request
        emit(state.copyWith(isLoading: true));
        try {
          await goRepository.denyFriendRequest(token, event.friendID);
          myNotifications.removeWhere(
              (element) => element.notificationID == event.friendID);

          emit(state.copyWith(
              myNotifications: myNotifications, isLoading: false));
        } catch (e) {
          print(e.toString());
          emit(state.copyWith(isLoading: false, error: e.toString()));
        }
      }
    });

    on<AlbumRequestEvent>((event, emit) async {
      List<Notification> myNotifications = [];
      myNotifications = List.from(state.myNotifications);

      if (event.action == RequestAction.accept) {
        // Accept Album Invite
        emit(state.copyWith(isLoading: true));

        try {
          List<Album> myAlbums = [];

          await goRepository.acceptAlbumInvite(token, event.albumID);

          myNotifications.removeWhere(
              (element) => element.notificationID == event.albumID);
          myAlbums = await goRepository.getUsersAlbums(token);

          emit(
            state.copyWith(
              isLoading: false,
              myNotifications: myNotifications,
              myAlbums: myAlbums,
            ),
          );
        } catch (e) {
          print(e.toString());
          emit(state.copyWith(isLoading: false, error: e.toString()));
        }
      } else if (event.action == RequestAction.deny) {
        // Deny Album Invite
        emit(state.copyWith(isLoading: true));
        try {
          await goRepository.denyAlbumInvite(token, event.albumID);
          myNotifications.removeWhere(
              (element) => element.notificationID == event.albumID);

          emit(state.copyWith(
              myNotifications: myNotifications, isLoading: false));
        } catch (e) {
          print(e.toString());
          emit(state.copyWith(isLoading: false, error: e.toString()));
        }
      }
    });

    /*on<ReceiveNotification>((event, emit) async {
      List<Notification> myNotifications = [];
      myNotifications = List.from(state.myNotifications);

      Notification notification = await dataRepository.getReceivedNotification(
          event.notificationType, event.identifier);
      myNotifications.insert(0, notification);

      emit(state.copyWith(
          myNotifications: myNotifications, showNotification: true));
      await Future.delayed(const Duration(seconds: 4));
      emit(state.copyWith(showNotification: false));
    });

    on<NotificationRemoved>(
      (event, emit) {
        List<Notification> myNotifications = [];
        myNotifications = List.from(state.myNotifications);

        var type = event.notificationType;

        myNotifications.removeWhere((element) {
          switch (type) {
            case NotificationType.albumInvite:
              if (element is AlbumInviteNotification &&
                  element.notificationID == event.identifier) {
                return true;
              }
            case NotificationType.friendRequest:
              if (element is FriendRequestNotification &&
                  element.notifierID == event.identifier) {
                return true;
              }
            case NotificationType.generic:
          }

          return false;
        });

        print(myNotifications);

        emit(state.copyWith(myNotifications: myNotifications));
      },
    );*/

    on<LoadNotifications>((event, emit) async {
      int index = event.index;
      List<Notification> myNotifications = [];

      emit(state.copyWith(isLoading: true));

      //Fill the list if it is empty - eventually will add the realtime update here
      if (state.myNotifications.isEmpty) {
        emit(
            state.copyWith(myNotifications: myNotifications, isLoading: false));
      }

      //Grab the URL of the media as it becomes available.
      if (event.location == LoadLocation.list) {
        emit(state.copyWith(isLoading: true));
        //Grab notifications from state emitted above;
        myNotifications = state.myNotifications;
        Notification notification = myNotifications[index];

        //Get the ID to pass to the fetchSignURL function
        String imageId = notification.notificationMediaID;

        //Assign the notification to MediaURL in notification
        //Then set that equal to the index in the list
        myNotifications[index] = notification;

        emit(
            state.copyWith(myNotifications: myNotifications, isLoading: false));
      }
      emit(state.copyWith(isLoading: false));
    });

    on<FetchProfileAlbumCoverURL>(
      (event, emit) async {
        int index = event.index;
        DateTime revealDT =
            DateTime.parse(state.myAlbums[index].revealDateTime);
        List<Album> listOfAlbums = state.myAlbums;
        Album album = state.myAlbums[index];
        String albumCoverID = album.albumCoverId;

        emit(state.copyWith(isLoading: true));

        /*if (state.myAlbums[index].images.isEmpty ||
            revealDT.isBefore(DateTime.now())) {
          try {
            album.albumCoverUrl =
                await dataRepository.fetchSignedUrl(albumCoverID);
            listOfAlbums[index] = album;
            emit(state.copyWith(isLoading: false, myAlbums: listOfAlbums));
          } catch (e) {
            emit(state.copyWith(error: e.toString(), isLoading: false));
            emit(state.copyWith(error: ''));
          }
        } else if (album.images[0].imageUrl == null) {
          String firstImage = album.images[0]!.imageId;
          try {
            album.albumCoverUrl =
                await dataRepository.fetchSignedUrl(firstImage);
            listOfAlbums[index] = album;
            emit(state.copyWith(isLoading: false, myAlbums: listOfAlbums));
          } catch (e) {
            emit(state.copyWith(error: e.toString(), isLoading: false));
            emit(state.copyWith(error: ''));
          }
        } else if (album.images[0].imageUrl == null) {
          emit(state.copyWith(isLoading: false));
        }*/
      },
    );

    /*Stream<(bool, String, NotificationType)> notificationStream =
        dataRepository.receivedNotification();

    Stream<(bool, String, NotificationType)> deletedStream =
        dataRepository.notificationRemoved();*/

    /*notificationStream.listen((event) {
      var (
        bool isRequest,
        String identifier,
        NotificationType notificationType
      ) = event;
      if (isRequest == true) {
        add(ReceiveNotification(
            identifier: identifier, notificationType: notificationType));
      }
    });

    deletedStream.listen((event) {
      var (
        bool isRequest,
        String identifier,
        NotificationType notificationType
      ) = event;
      if (isRequest == true) {
        add(NotificationRemoved(
            identifier: identifier, notificationType: notificationType));
      }
    });*/

    if (appBloc.state is AuthenticatedState) {
      add(InitializeProfile());
    }
  }
}
