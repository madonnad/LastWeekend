part of 'create_album_cubit.dart';

class CreateAlbumState extends Equatable {
  final TextEditingController? albumName;
  final String? albumCoverImagePath;
  final List<String>? invitedFriends;
  // Unlock Date Variables
  final DateTime? unlockDateTime;
  final TimeOfDay? unlockTimeOfDay;
  // Lock Date Variables
  final DateTime? lockDateTime;
  final TimeOfDay? lockTimeOfDay;
  // Reveal Date Variables
  final DateTime? revealDateTime;
  final TimeOfDay? revealTimeOfDay;

  const CreateAlbumState({
    this.albumName,
    this.albumCoverImagePath,
    this.invitedFriends,
    // Unlock Date Variables
    this.unlockDateTime,
    this.unlockTimeOfDay,
    // Lock Date Variables
    this.lockDateTime,
    this.lockTimeOfDay,
    // Reveal Date Variables
    this.revealDateTime,
    this.revealTimeOfDay,
  });

  CreateAlbumState copyWith({
    TextEditingController? albumName,
    String? albumCoverImagePath,
    List<String>? invitedFriends,
    DateTime? unlockDateTime,
    TimeOfDay? unlockTimeOfDay,
    DateTime? lockDateTime,
    TimeOfDay? lockTimeOfDay,
    String? lockTimeString,
    DateTime? revealDateTime,
    TimeOfDay? revealTimeOfDay,
  }) {
    return CreateAlbumState(
      albumName: albumName ?? this.albumName,
      albumCoverImagePath: albumCoverImagePath ?? this.albumCoverImagePath,
      invitedFriends: invitedFriends ?? this.invitedFriends,
      unlockDateTime: unlockDateTime ?? this.unlockDateTime,
      unlockTimeOfDay: unlockTimeOfDay ?? this.unlockTimeOfDay,
      lockDateTime: lockDateTime ?? this.lockDateTime,
      lockTimeOfDay: lockTimeOfDay ?? this.lockTimeOfDay,
      revealDateTime: revealDateTime ?? this.revealDateTime,
      revealTimeOfDay: revealTimeOfDay ?? this.revealTimeOfDay,
    );
  }

  //? Nulling copyWiths

  CreateAlbumState copyWithNullLockDate() {
    return CreateAlbumState(
      albumName: albumName,
      albumCoverImagePath: albumCoverImagePath,
      invitedFriends: invitedFriends,
      unlockDateTime: unlockDateTime,
      unlockTimeOfDay: unlockTimeOfDay,
      lockDateTime: null,
      lockTimeOfDay: null,
      revealDateTime: revealDateTime,
      revealTimeOfDay: revealTimeOfDay,
    );
  }

  CreateAlbumState copyWithNullRevealDate() {
    return CreateAlbumState(
      albumName: albumName,
      albumCoverImagePath: albumCoverImagePath,
      invitedFriends: invitedFriends,
      unlockDateTime: unlockDateTime,
      unlockTimeOfDay: unlockTimeOfDay,
      lockDateTime: lockDateTime,
      lockTimeOfDay: lockTimeOfDay,
      revealDateTime: null,
      revealTimeOfDay: null,
    );
  }

  @override
  List<Object?> get props => [
        albumName,
        albumCoverImagePath,
        invitedFriends,
        unlockDateTime,
        unlockTimeOfDay,
        lockDateTime,
        lockTimeOfDay,
        revealDateTime,
        revealTimeOfDay,
        revealTimeString,
      ];

  //? Date Getters and Formatter

  String? get unlockDateString {
    String? date;
    if (unlockDateTime != null) {
      date = dateFormatter(unlockDateTime!);
      return date;
    }
    return date = null;
  }

  String? get lockDateString {
    String? date;
    if (lockDateTime != null) {
      date = dateFormatter(lockDateTime!);
      return date;
    }
    return date = null;
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
      dateString = DateFormat("MMM d, ''yy").format(dateTime);
      return dateString;
    }
    return dateString = DateFormat("MMM d").format(dateTime);
  }

  //? Time Getters and Formatter

  String? get unlockTimeString {
    String? time;
    if (unlockTimeOfDay != null) {
      time = timeFormatter(unlockTimeOfDay!);
      return time;
    }
    return time = null;
  }

  String? get lockTimeString {
    String? time;
    if (lockTimeOfDay != null) {
      time = timeFormatter(lockTimeOfDay!);
      return time;
    }
    return time = null;
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
    String ampm = 'am';
    String timeString;

    if (time.hour % 12 != time.hour) {
      ampm = 'pm';
      hour = (time.hour - 12).toString();
    }

    if (time.minute < 10) {
      minute = '0${time.minute.toString()}';
    }

    timeString = '$hour:$minute $ampm';
    return timeString;
  }
}
