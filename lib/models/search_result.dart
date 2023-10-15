enum ResultType { album, user }

abstract class SearchResult {
  final String userID;
  final String firstName;
  final String lastName;
  final ResultType resultType;

  SearchResult({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.resultType,
  });

  String get fullName {
    return "$firstName $lastName";
  }
}

class AlbumSearch extends SearchResult {
  final String albumID;
  final String albumName;
  AlbumSearch({
    required super.userID,
    required super.firstName,
    required super.lastName,
    required this.albumID,
    required this.albumName,
  }) : super(resultType: ResultType.album);
}

class UserSearch extends SearchResult {
  UserSearch({
    required super.userID,
    required super.firstName,
    required super.lastName,
  }) : super(resultType: ResultType.user);
}
