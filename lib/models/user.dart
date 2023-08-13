// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final List<dynamic>? friendsList;

  // Constructors
  const User({
    required this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.friendsList,
  });

  static const empty = User(id: '');

  // Getters
  // Getter to check if the current user is empty
  bool get isEmpty => this == User.empty;
  // Getter to check if the current user is not empty
  bool get isNotEmpty => this != User.empty;

  //Equatable overrides
  @override
  List<Object?> get props =>
      [email, id, firstName, lastName, avatarUrl, friendsList];
}
