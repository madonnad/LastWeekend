// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:shared_photo/utils/api_variables.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? username;
  final String firstName;
  final String lastName;
  final String token;
  final bool newAccount;
  final DateTime? createdDateTime;

  // Constructors
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.newAccount,
    this.createdDateTime,
    this.email,
    this.username,
  });

  User copyWith(
      {String? id, String? firstName, String? lastName, bool? newAccount}) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username,
      token: token,
      newAccount: newAccount ?? this.newAccount,
      createdDateTime: createdDateTime,
      email: email,
    );
  }

  static const empty = User(
    id: '',
    firstName: '',
    lastName: '',
    token: '',
    newAccount: false,
  );

  // Getters
  // Getter to check if the current user is empty
  bool get isEmpty => this == User.empty;
  // Getter to check if the current user is not empty
  bool get isNotEmpty => this != User.empty;

  Map<String, String> get headers => {"Authorization": "Bearer $token"};
  String get avatarUrl => "$goRepoDomain/image?id=$id";

  String get fullName => '$firstName $lastName';

  //Equatable overrides
  @override
  List<Object?> get props =>
      [email, id, firstName, lastName, token, newAccount];
}
