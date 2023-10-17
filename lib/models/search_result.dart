import 'package:flutter/material.dart';
import 'package:shared_photo/utils/api_variables.dart';

enum ResultType { album, user }

abstract class SearchResult {
  final String id;
  final String firstName;
  final String lastName;
  final ResultType resultType;
  final double rank;
  final Image image;

  SearchResult(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.resultType,
      required this.rank,
      required this.image});

  String get fullName {
    return "$firstName $lastName";
  }

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$id";

    return requestUrl;
  }
}

class AlbumSearch extends SearchResult {
  final String albumName;
  AlbumSearch({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.rank,
    required super.image,
    required this.albumName,
  }) : super(resultType: ResultType.album);

  factory AlbumSearch.fromMap(
      Map<String, dynamic> map, Map<String, String> headers) {
    String requestUrl = "$goRepoDomain/image?id=${map['asset']}";

    return AlbumSearch(
      id: map["id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      rank: map["score"].toDouble(),
      albumName: map["name"],
      image: Image.network(
        requestUrl,
        headers: headers,
      ),
    );
  }
}

class UserSearch extends SearchResult {
  UserSearch({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.rank,
    required super.image,
  }) : super(resultType: ResultType.user);

  factory UserSearch.fromMap(
      Map<String, dynamic> map, Map<String, String> headers) {
    String requestUrl = "$goRepoDomain/image?id=${map['asset']}";

    return UserSearch(
      id: map["id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      rank: map["score"].toDouble(),
      image: Image.network(
        requestUrl,
        headers: headers,
      ),
    );
  }
}
