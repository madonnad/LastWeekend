part of 'create_album_cubit.dart';

enum FriendState {
  empty,
  searching,
}

enum DurationEvent {
  oneDay("24 Hours"),
  twoDays("2 Days"),
  oneWeek("1 Week"),
  custom("Custom");

  final String description;

  const DurationEvent(this.description);
}

final class CreateEventState extends Equatable {
  final TextEditingController albumName;
  final TextEditingController? friendSearch;
  final String? eventTitle;
  final String? albumCoverImagePath;
  final String? albumUID;
  final AlbumVisibility? visibility;
  // Reveal Date Variables
  final DateTime? revealDateTime;
  final TimeOfDay? revealTimeOfDay;
  // Friends List
  final Map<String, Friend> friendsMap;
  final List<Friend> invitedFriends;
  final List<Friend> searchResult;
  final FriendState friendState;
  final bool loading;
  final CustomException exception;
  final DurationEvent? durationEvent;

  const CreateEventState({
    required this.albumName,
    required this.friendSearch,
    this.eventTitle,
    this.albumCoverImagePath,
    this.albumUID,
    // Reveal Date Variables
    this.revealDateTime,
    this.revealTimeOfDay,
    //Friends
    required this.friendsMap,
    this.invitedFriends = const [],
    this.searchResult = const [],
    this.friendState = FriendState.empty,
    this.loading = false,
    this.visibility,
    this.exception = CustomException.empty,
    this.durationEvent,
  });

  CreateEventState copyWith({
    TextEditingController? albumName,
    TextEditingController? friendSearch,
    String? eventTitle,
    String? albumCoverImagePath,
    String? albumUID,
    List<Friend>? invitedFriends,
    DateTime? revealDateTime,
    TimeOfDay? revealTimeOfDay,
    Map<String, Friend>? friendsMap,
    List<Friend>? searchResult,
    FriendState? friendState,
    bool? loading,
    AlbumVisibility? visibility,
    CustomException? exception,
    DurationEvent? durationEvent,
  }) {
    return CreateEventState(
      albumName: albumName ?? this.albumName,
      friendSearch: friendSearch ?? this.friendSearch,
      eventTitle: eventTitle ?? this.eventTitle,
      albumCoverImagePath: albumCoverImagePath ?? this.albumCoverImagePath,
      albumUID: albumUID ?? this.albumUID,
      invitedFriends: invitedFriends ?? this.invitedFriends,
      revealDateTime: revealDateTime ?? this.revealDateTime,
      revealTimeOfDay: revealTimeOfDay ?? this.revealTimeOfDay,
      friendsMap: friendsMap ?? this.friendsMap,
      searchResult: searchResult ?? this.searchResult,
      friendState: friendState ?? this.friendState,
      loading: loading ?? this.loading,
      visibility: visibility ?? this.visibility,
      exception: exception ?? this.exception,
      durationEvent: durationEvent ?? this.durationEvent,
    );
  }

  @override
  List<Object?> get props => [
        albumName,
        friendSearch,
        eventTitle,
        albumCoverImagePath,
        albumUID,
        invitedFriends,
        revealDateTime,
        revealTimeOfDay,
        revealTimeString,
        friendsMap,
        searchResult,
        friendState,
        loading,
        visibility,
        exception,
        durationEvent,
      ];

  bool get canCreate {
    return (albumCoverImagePath != null &&
        revealDateTime != null &&
        revealTimeOfDay != null &&
        albumName.text.isNotEmpty &&
        visibility != null);
  }

  //? Friend Getters

  List<String> get invitedUIDList {
    List<String> uidList = invitedFriends.map((e) => e.uid).toList();
    return uidList;
  }

  List<Friend> get friendsList {
    return friendsMap.values.toList();
  }

  //? Date Getters and Formatter

  DateTime get finalRevealDateTime {
    DateTime dateTime = DateTime(1900);
    if (revealDateTime != null && revealTimeOfDay != null) {
      dateTime = DateTime(
        revealDateTime!.year,
        revealDateTime!.month,
        revealDateTime!.day,
        revealTimeOfDay!.hour,
        revealTimeOfDay!.minute,
        0,
      );
    }
    return dateTime;
  }

  String? get revealDateString {
    String? date;
    if (revealDateTime != null) {
      date = dateFormatter(revealDateTime!);
      return date;
    }
    return date = null;
  }

  String dateFormatter(DateTime dateTime) {
    String dateString;
    if (dateTime.year != DateTime.now().year) {
      dateString = DateFormat("EEE MMM d, ''yy").format(dateTime);
      return dateString;
    }
    return dateString = DateFormat("EEE MMM d").format(dateTime);
  }

  String? get revealTimeString {
    String? time;
    if (revealTimeOfDay != null) {
      time = timeFormatter(revealTimeOfDay!);
      return time;
    }
    return time = null;
  }

  String timeFormatter(TimeOfDay time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString();
    String amPm = 'AM';
    String timeString;

    //This fires after noon, but does not include noon
    if (time.hour % 12 != time.hour) {
      amPm = 'PM';
      hour = (time.hour - 12).toString();
    }

    if (time.hour == 12) {
      amPm = 'PM';
      hour = 12.toString();
    }

    if (time.hour == 0) {
      amPm = 'AM';
      hour = 12.toString();
    }

    if (time.minute < 10) {
      minute = '0${time.minute.toString()}';
    }

    timeString = '$hour:$minute $amPm';
    return timeString;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> inviteJson =
        invitedFriends.map((e) => e.toJson()).toList();
    String visibilityString;

    switch (visibility) {
      case AlbumVisibility.public:
        visibilityString = "public";
      case AlbumVisibility.private:
        visibilityString = "private";
      case AlbumVisibility.friends:
        visibilityString = "friends";
      default:
        visibilityString = "private";
    }

    return {
      "album_name": eventTitle,
      "invite_list": inviteJson,
      // "unlocked_at": finalUnlockDateTime.toUtc().toIso8601String(),
      // "locked_at": finalLockDateTime.toUtc().toIso8601String(),
      "revealed_at": finalRevealDateTime.toUtc().toIso8601String(),
      "visibility": visibilityString,
    };
  }
}
