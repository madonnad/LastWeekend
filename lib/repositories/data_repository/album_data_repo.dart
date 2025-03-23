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

  Future<Album?> getAlbumByID(String albumID) async {
    Album? album;
    bool? success;

    (_, album) = await AlbumService.getAlbumByID(user.token, albumID);
    if (album == null) {
      return album;
    }

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

    Album newAlbum = albumMap[albumID]!.copyWith(imageMap: imageMap);
    //albumMap[albumID]!.imageMap = imageMap;

    albumMap[albumID] = newAlbum;

    if (albumMap.containsKey(albumID) &&
        albumMap[albumID]!.imageMap.isNotEmpty) {
      return albumMap[albumID]!.imageMap;
    }
    return {};
  }

  Map<String, Album> activeAlbums() {
    Map<String, Album> test = albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            album.phase != AlbumPhases.reveal)
        .fold({}, (map, album) => map..[album.albumId] = album);
    return test;
  }

  Map<String, Album> unlockedAlbums() {
    return albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            album.phase == AlbumPhases.open)
        .fold({}, (map, album) => map..[album.albumId] = album);
  }

  Map<String, Album> profileAlbums() {
    Map<String, Album> test = albumMap.values
        .where((album) =>
            album.guests.any((guest) => guest.uid == user.id) &&
            (album.phase == AlbumPhases.reveal ||
                album.phase == AlbumPhases.open))
        .fold({}, (map, album) => map..[album.albumId] = album);
    // print(test);
    return test;
  }

  // Create New Album
  Future<(bool, String?)> createAlbum({required CreateEventState state}) async {
    bool success = false;
    String? error;
    Album? album;
    (album, error) = await AlbumService.postNewAlbum(user.token, state);
    if (album == null) {
      return (false, error);
    }

    String? albumCoverPath = state.albumCoverImagePath;
    if (albumCoverPath == null) {
      return (false, "No image path was provided to upload");
    }

    (success, error) = await ImageService.uploadPhoto(
      user.token,
      albumCoverPath,
      album.albumCoverId,
      StreamController<double>.broadcast(),
    );
    if (success == false) {
      return (false, error);
    }

    _albumController.add((StreamOperation.add, album));
    return (true, null);
  }

  Future<List<Album>> getRevealedAlbumsByAlbumID(List<String> albumIDs) async {
    List<String> newAlbumIds = [];

    for (String id in albumIDs) {
      if (!albumMap.containsKey(id)) {
        newAlbumIds.add(id);
      }
    }

    List<Album> albums =
        await AlbumService.getRevealedAlbumsByAlbumID(user.token, albumIDs);

    for (Album album in albums) {
      albumMap.update(album.albumId, (value) => album, ifAbsent: () => album);
    }

    albums = albumMap.entries
        .where((element) => albumIDs.contains(element.key))
        .map((e) => e.value)
        .toList();

    return albums;
  }

  Future<(bool, String?)> inviteUserToAlbum(String albumID, String guestID,
      String guestFirst, String guestLast) async {
    bool albumExists = albumMap.containsKey(albumID);

    if (!albumExists) return (false, "Album does not exist");

    Album album = Album.from(albumMap[albumID]!);

    bool requestSent;
    String? error;

    (requestSent, error) =
        await AlbumService.postSingleAlbumRequest(user.token, albumID, guestID);

    if (!requestSent) return (false, error);

    Guest addedGuest = Guest(
      uid: guestID,
      firstName: guestFirst,
      lastName: guestLast,
      status: RequestStatus.pending,
    );

    album.guestMap[guestID] = addedGuest;

    _albumController.add((StreamOperation.update, album));
    return (true, null);
  }

  Future<(bool, String?)> updateAlbumVisibility(String albumID,
      String visibilityString, AlbumVisibility visibility) async {
    bool success = false;
    String? error;

    if (albumMap[albumID] == null) return (false, "Event Does Not Exist");

    (success, error) = await AlbumService.updateAlbumVisibility(
        user.token, albumID, visibilityString);

    if (!success) return (success, error);

    Album album = albumMap[albumID]!.copyWith(visibility: visibility);

    albumMap[albumID] = album;

    _albumController.add((StreamOperation.update, album));
    return (true, null);
  }

  Future<(bool, String?)> updateEventOwnership(
      String albumID, Guest guest) async {
    bool success = false;
    String? error;

    if (albumMap[albumID] == null) return (false, "Event Does Not Exist");

    (success, error) =
        await AlbumService.updateEventOwnership(user.token, guest.uid, albumID);

    if (!success) return (success, error);

    Album album = albumMap[albumID]!.copyWith(
      albumOwner: guest.uid,
      ownerFirst: guest.firstName,
      ownerLast: guest.lastName,
    );

    albumMap[albumID] = album;

    _albumController.add((StreamOperation.update, album));
    return (true, null);
  }

  Future<(bool, String?)> updateDatetime(
      String albumID, DateTime datetime) async {
    bool success = false;
    String? error;
    Album? album = albumMap[albumID];
    if (album == null) return (false, "Event Does Not Exist");

    (success, error) =
        await AlbumService.updateEventTimeline(user.token, albumID, datetime);

    if (!success) return (success, error);

    Album updatedAlbum = album.copyWith(revealDateTime: datetime);

    albumMap[albumID] = updatedAlbum;

    _albumController.add((StreamOperation.update, updatedAlbum));
    return (true, null);
  }

  Future<(bool, String?)> deleteLeaveEvent(String albumID) async {
    bool success = false;
    String? error;
    Album? album = albumMap[albumID];
    if (album == null) return (false, "Event Does Not Exist");

    (success, error) = await AlbumService.deleteLeaveEvent(user.token, albumID);

    if (!success) return (success, error);

    albumMap.remove(albumID);

    if (album.visibility == AlbumVisibility.public) {
      _albumController.add((StreamOperation.update, album));
    } else {
      _albumController.add((StreamOperation.delete, album));
    }

    return (true, null);
  }

  Future<(bool, String?)> deleteEvent(String albumID) async {
    bool success = false;
    String? error;
    Album? album = albumMap[albumID];

    if (album == null) return (false, "Event Does Not Exist");

    (success, error) = await AlbumService.deleteEvent(user.token, albumID);

    if (!success) return (success, error);
    albumMap.remove(albumID);

    _albumController.add((StreamOperation.delete, album));
    return (true, null);
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

    bool albumExists = albumMap.containsKey(albumID);

    switch (notification.status) {
      case RequestStatus.pending:
        break;
      case RequestStatus.accepted:
        if (notification.guestID != user.id &&
            albumMap[albumID]?.guestMap[guestID] != null &&
            albumExists) {
          albumMap[albumID]!.guestMap[guestID]!.status = RequestStatus.accepted;
          _albumController.add((StreamOperation.update, albumMap[albumID]!));
          return;
        }
        if (notification.guestID == user.id) {
          // if (!albumExists) {
          getAlbumByID(albumID);
          return;
          // }
          // _albumController.add((StreamOperation.update, albumMap[albumID]!));
          // return;
        }
      case RequestStatus.denied:
        if (notification.guestID != user.id && albumExists) {
          albumMap[albumID]!.guestMap[guestID]!.status = RequestStatus.denied;
          _albumController.add((StreamOperation.update, albumMap[albumID]!));
          return;
        }
      case RequestStatus.abandoned:
        break;
    }
  }
}
