import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/repositories/data_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppBloc appBloc;
  final DataRepository dataRepository;

  ProfileBloc({required this.appBloc, required this.dataRepository})
      : super(ProfileState.empty) {
    on<InitializeProfile>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      List<Album> myAlbums = await dataRepository.fetchMyAlbums();
      emit(state.copyWith(myAlbums: myAlbums, isLoading: false));
    });

    on<ReceiveNotifcation>((event, emit) async {
      List<Notification> myNotifications = [];
      myNotifications = state.myNotifications;

      Notification notification = await dataRepository.getReceivedNotification(
          event.notificationType, event.identifier);
      myNotifications.insert(0, notification);

      emit(state.copyWith(myNotifications: myNotifications));
    });

    on<LoadNotifications>((event, emit) async {
      int index = event.index;
      List<Notification> myNotifications = [];

      emit(state.copyWith(isLoading: true));

      //Fill the list if it is empty - eventually will add the realtime update here
      if (state.myNotifications.isEmpty) {
        myNotifications = await dataRepository.fetchMyNotifications();
        emit(
            state.copyWith(myNotifications: myNotifications, isLoading: false));
      }

      //Grab the URL of the media as it becomes available.
      if (event.location == LoadLocation.list &&
          state.myNotifications[index].notificationMediaURL == null) {
        emit(state.copyWith(isLoading: true));
        //Grab notifications from state emitted above;
        myNotifications = state.myNotifications;
        Notification notification = myNotifications[index];

        //Get the ID to pass to the fetchSignURL function
        String imageId = notification.notificationMediaID;
        String notificationMediaURL =
            await dataRepository.fetchSignedUrl(imageId);

        //Assign the notification to MediaURL in notification
        //Then set that equal to the index in the list
        notification.notificationMediaURL = notificationMediaURL;
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

        if (state.myAlbums[index].images.isEmpty ||
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
        }
      },
    );

    Stream<(bool, String)> albumRequestStream =
        dataRepository.receivedAlbumRequest();

    albumRequestStream.listen((event) {
      var (bool isRequest, String albumId) = event;
      if (isRequest == true) {
        add(ReceiveNotifcation(
            identifier: albumId,
            notificationType: NotificationType.albumInvite));
      }
    });

    if (appBloc.state is AuthenticatedState) {
      add(InitializeProfile());
    }
  }
}
