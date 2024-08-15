import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/user_service.dart';

class Auth0Repository {
  final auth0 = Auth0(
    dotenv.env['AUTH0_DOMAIN'] ?? '',
    dotenv.env['AUTH0_ID'] ?? '',
  );
  final String connection = "Username-Password-Authentication";
  bool newAccount = false;

  final _userController = StreamController<(User, CustomException)>();

  Stream<(User, CustomException)> get user => _userController.stream;

  Future<void> userStream() async {
    bool hasCreds = await auth0.credentialsManager.hasValidCredentials();

    bool expired = false;
    late Credentials creds;
    try {
      creds = await auth0.credentialsManager.credentials();
      expired = creds.expiresAt.isBefore(DateTime.now());
    } catch (e) {
      expired = true;
    }

    if (hasCreds && !expired) {
      UserProfile userProfile = creds.user;

      String email = userProfile.email != null ? userProfile.email! : 'email';

      if (newAccount) {
        String firstName =
            userProfile.givenName != null ? userProfile.givenName! : 'first';
        String lastName =
            userProfile.familyName != null ? userProfile.familyName! : 'last';
        (int, String?) creationStatus = await UserService.createUserEntry(
            creds.accessToken, firstName, lastName, email);

        if (creationStatus.$1 != 200) {
          _userController.sink.add((
            User.empty,
            CustomException(
              errorString: creationStatus.$2,
            )
          ));
          return;
        }
      }

      User user = await getInternalUserInformation(
          creds.accessToken, email, newAccount);

      newAccount = false;

      _userController.sink.add((user, CustomException.empty));
      return;
    }

    await auth0.credentialsManager.clearCredentials();

    _userController.sink.add((User.empty, CustomException.empty));
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

      newAccount = true;

      loginWithEmailAndPassword(email: user.email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    String audience = dotenv.env["AUTH0_AUDIENCE"] ?? '';
    try {
      print('before login');
      Credentials credentials = await auth0.api.login(
        usernameOrEmail: email,
        password: password,
        connectionOrRealm: connection,
        audience: audience,
      );
      print('after login');

      bool didStore =
          await auth0.credentialsManager.storeCredentials(credentials);

      userStream();
      if (!didStore) {
        throw Exception("Failed to store credentials");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    await auth0.api.resetPassword(email: email, connection: connection);
  }

  Future<void> logout() async {
    await auth0.credentialsManager.clearCredentials();
    userStream();
  }

  Future<User> getInternalUserInformation(
      String token, String email, bool newAccount) async {
    //String domain = dotenv.env['DOMAIN'] ?? '';
    //var url = Uri.https(domain, '/user');
    String urlString = "${dotenv.env['URL']}/user";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        throw const HttpException("No user exists with the provided token");
      }

      String userId = jsonData["user_id"];
      String first = jsonData["first_name"];
      String last = jsonData["last_name"];
      DateTime createdDateTime = DateTime.parse(jsonData["created_at"]);

      return User(
        id: userId,
        email: email,
        firstName: first,
        lastName: last,
        token: token,
        createdDateTime: createdDateTime,
        newAccount: newAccount,
      );
    }

    logout();

    return User.empty;

    // throw HttpException(
    //     "Failed to get users information with status: ${response.statusCode}");
  }
}
