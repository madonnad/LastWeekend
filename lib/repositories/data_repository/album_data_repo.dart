part of './data_repository.dart';

extension AlbumDataRepo on DataRepository {
  Future<void> _initalizeAlbums() async {
    albumMap = await _setAppWideAlbums();
  }

  Future<Map<String, Album>> _setAppWideAlbums() async {
    List<Album> tempList = [];
    List<Album> usersAlbums = [];
    List<Album> feedAlbums = [];

    usersAlbums = await AlbumService.getAuthUsersAlbums(user.token);
    feedAlbums = await AlbumService.getFeedAlbums(user.token);

    _feedController.add((StreamOperation.add, feedAlbums));

    tempList.addAll(usersAlbums + feedAlbums);

    for (Album album in tempList) {
      albumMap.putIfAbsent(album.albumId, () {
        _albumController.add((StreamOperation.add, album));
        return album;
      });
    }

    return albumMap;
  }

  Future<Album> getAlbumByID(String albumID) async {
    Album album = await AlbumService.getAlbumByID(user.token, albumID);

    albumMap[album.albumId] = album;
    _albumController.add((StreamOperation.add, album));
    return album;
  }

  // Initializer Functions

  Future<Map<String, Photo>> getAlbumImages(String albumID) async {
    List<Photo> imageList =
        await ImageService.getAlbumImages(user.token, albumID);

    Map<String, Photo> imageMap = {};

    for (Photo image in imageList) {
      imageMap.putIfAbsent(image.imageId, () => image);
    }

    if (albumMap[albumID] == null) return imageMap;

    albumMap[albumID]!.imageMap = imageMap;

    if (albumMap.containsKey(albumID) &&
        albumMap[albumID]!.imageMap.isNotEmpty) {
      return albumMap[albumID]!.imageMap;
    }
    return {};
  }

  Map<String, Album> activeAlbums() {
    return albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            album.phase != AlbumPhases.reveal)
        .fold({}, (map, album) => map..[album.albumId] = album);
  }

  Map<String, Album> unlockedAlbums() {
    return albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            album.phase == AlbumPhases.unlock)
        .fold({}, (map, album) => map..[album.albumId] = album);
  }

  Map<String, Album> profileAlbums() {
    return albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            album.phase == AlbumPhases.reveal)
        .fold({}, (map, album) => map..[album.albumId] = album);
  }

  // Create New Album

  Future<(bool, String?)> createAlbum({required CreateAlbumState state}) async {
    try {
      Album? album = await AlbumService.postNewAlbum(user.token, state);
      if (album == null) {
        throw const FormatException("Failed creating new image");
      }

      String? albumCoverPath = state.albumCoverImagePath;
      if (albumCoverPath == null) {
        throw const FormatException("No image path was provided to upload");
      }

      bool success = await ImageService.postAlbumCoverImage(
          user.token, albumCoverPath, album.albumCoverId);
      if (success == false) {
        throw const FormatException("Image upload failed");
      }

      _albumController.add((StreamOperation.add, album));
      return (true, null);
    } catch (e) {
      print(e);
      return (false, e.toString());
    }
  }

  Future<List<Album>> getRevealedAlbumsByAlbumID(List<String> albumIDs) async {
    List<String> newAlbumIds = [];

    for (String id in albumIDs) {
      if (!albumMap.containsKey(id)) {
        newAlbumIds.add(id);
      }
    }

    List<Album> albums =
        await AlbumService.getRevealedAlbumsByAlbumID(user.token, newAlbumIds);

    for (Album album in albums) {
      albumMap.putIfAbsent(album.albumId, () => album);
    }

    albums = albumMap.entries
        .where((element) => albumIDs.contains(element.key))
        .map((e) => e.value)
        .toList();

    return albums;
  }

  // Future<List<Guest>> updateAlbumsGuests(String albumID) async {
  //   List<Guest> fetchedGuests =
  //       await AlbumService.updateGuestList(user.token, albumID);

  //   albumMap[albumID]!.guests = fetchedGuests;

  //   return fetchedGuests;
  // }

  void _handleInviteResponse(AlbumInviteNotification notification) {
    String albumID = notification.albumID;
    String guestID = notification.guestID;

    bool albumExists = albumMap.containsKey(albumID) ? true : false;

    switch (notification.status) {
      case RequestStatus.pending:
        return;
      case RequestStatus.accepted:
        if (notification.guestID != user.id && albumExists) {
          albumMap[albumID]!.guestMap[guestID]!.status = RequestStatus.accepted;
          _albumController.add((StreamOperation.update, albumMap[albumID]!));
          return;
        }
        if (notification.guestID == user.id) {
          if (!albumExists) {
            getAlbumByID(albumID);
            return;
          }
          _albumController.add((StreamOperation.update, albumMap[albumID]!));
          return;
        }
      case RequestStatus.denied:
        if (notification.guestID != user.id && albumExists) {
          albumMap[albumID]!.guestMap[guestID]!.status = RequestStatus.denied;
          _albumController.add((StreamOperation.update, albumMap[albumID]!));
          return;
        }
    }
  }
}
