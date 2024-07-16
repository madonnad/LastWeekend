import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/models/image_change.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final DataRepository dataRepository;
  final User user;

  ProfileBloc({
    required this.userRepository,
    required this.dataRepository,
    required this.user,
  }) : super(ProfileState.createWithUser(user: user)) {
    // Event Handlers
    on<InitializeProfile>(
      (event, emit) {
        emit(
          state.copyWith(
            myFriendsMap: Map.from(userRepository.friendMap),
            myAlbumsMap: dataRepository.profileAlbums(),
          ),
        );
      },
    );

    on<AddFriendToList>(
      (event, emit) {
        Map<String, Friend> friendMap = Map.from(state.myFriendsMap);

        Friend friend = event.friend;
        String key = friend.uid;

        if (!friendMap.containsKey(key) || friendMap[key] != friend) {
          friendMap[key] = friend;
          emit(state.copyWith(myFriendsMap: friendMap));
        }
      },
    );

    on<AddAlbumToMap>(
      (event, emit) {
        Map<String, Album> albumMap = Map.from(state.myAlbumsMap);

        Album album = event.album;
        String key = album.albumId;

        if (!albumMap.containsKey(key) || albumMap[key] != event.album) {
          albumMap[key] = album;
          emit(state.copyWith(myAlbumsMap: albumMap));
        }
      },
    );

    on<UpdateAlbumInMap>((event, emit) {
      Map<String, Album> albumMap = Map.from(state.myAlbumsMap);

      Album album = event.album;
      String key = album.albumId;

      albumMap.update(key, (value) => album, ifAbsent: () => album);
      emit(state.copyWith(myAlbumsMap: albumMap));
    });

    on<UpdateImageInAlbum>((event, emit) {
      Map<String, Album> profileAlbumMap = Map.from(state.myAlbumsMap);

      String albumID = event.imageChange.albumID;
      String imageID = event.imageChange.imageID;
      Photo image = event.imageChange.image;
      Album album = profileAlbumMap[albumID]!;

      Map<String, Photo> newImageMap = Map.from(album.imageMap);

      newImageMap.update(imageID, (value) => image, ifAbsent: () => image);

      Album newAlbum = album.copyWith(imageMap: newImageMap);
      profileAlbumMap[albumID] = newAlbum;

      emit(state.copyWith(myAlbumsMap: profileAlbumMap));
    });

    on<UpdateUser>((event, emit) {
      User user = event.user;

      emit(state.copyWith(user: user));
    });

    // Stream Listeners
    userRepository.friendStream.listen((event) {
      StreamOperation type = event.$1;
      Friend friend = event.$2;

      switch (type) {
        case StreamOperation.add:
          add(AddFriendToList(friend: friend));
        case StreamOperation.update:
        case StreamOperation.delete:
      }
    });

    userRepository.userStream.listen((event) {
      StreamOperation type = event.$1;
      User user = event.$2;

      switch (type) {
        case StreamOperation.add:
        case StreamOperation.update:
          add(UpdateUser(user: user));
        case StreamOperation.delete:
      }
    });

    dataRepository.albumStream.listen((event) {
      StreamOperation type = event.$1;
      Album album = event.$2;

      // Check if user is in the album that was passed
      bool userIsGuest = album.guests.any((guest) => guest.uid == user.id);

      if (userIsGuest && album.phase == AlbumPhases.reveal) {
        switch (type) {
          case StreamOperation.add:
            add(AddAlbumToMap(album: album));
          case StreamOperation.update:
            add(UpdateAlbumInMap(album: album));
          case StreamOperation.delete:
        }
      }
    });

    dataRepository.imageStream.listen((event) {
      String albumID = event.albumID;
      Album? album = state.myAlbumsMap[albumID];

      if (album != null) {
        add(UpdateImageInAlbum(imageChange: event));
      }
    });

    add(InitializeProfile());
  }
}
