import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/utils/api_key.dart';

class Auth0Repository {
  final auth0 = Auth0(auth0_domain, auth0_id);
  final String connection = "Username-Password-Authentication";

  final _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  Future<void> userStream() async {
    bool hasCreds = await auth0.credentialsManager.hasValidCredentials();

    if (hasCreds) {
      Credentials creds = await auth0.credentialsManager.credentials();
      UserProfile userProfile = creds.user;

      String firstName =
          userProfile.givenName != null ? userProfile.givenName! : 'first';
      String lastName =
          userProfile.familyName != null ? userProfile.familyName! : 'last';
      String email = userProfile.email != null ? userProfile.email! : 'email';

      _userController.sink.add(User(
        id: userProfile.sub,
        email: email,
        firstName: firstName,
        lastName: lastName,
        token: creds.accessToken,
      ));
      return;
    }
    _userController.sink.add(User.empty);
  }

  Future<void> createAccountWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      DatabaseUser user = await auth0.api.signup(
        email: email,
        password: password,
        connection: connection,
        parameters: {'given_name': firstName, 'family_name': lastName},
      );

      loginWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    String audience = "http://localhost:2525/go_services";
    try {
      Credentials credentials = await auth0.api.login(
          usernameOrEmail: email,
          password: password,
          connectionOrRealm: connection,
          audience: audience);

      bool didStore =
          await auth0.credentialsManager.storeCredentials(credentials);
      userStream();
      if (!didStore) {
        throw Exception("Failed to store credentials");
      }

      //print("token ${credentials.accessToken}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await auth0.credentialsManager.clearCredentials();
    userStream();
  }
}
