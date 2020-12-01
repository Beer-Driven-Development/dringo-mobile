import 'dart:async';
import 'dart:convert';

import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier, SecureStorageMixin {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      //final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = response.body;

      setSecureStorage("token", token);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'token': token};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<String> facebook() async {
    var accessToken = await FacebookAuth.instance.login();
    print(accessToken);
    return accessToken.toString();
  }

  Future<String> google() async {
    String idToken;
    var result;

    var googleSignInAccount = await GoogleSignIn(
            scopes: ['email'],
            clientId:
                '409741835950-e522n1uski07dmur1b06pt678otkg9ku.apps.googleusercontent.com')
        .signIn()
        .then((result) => result.authentication
            .then((googleKey) => idToken = googleKey.idToken));

    // print(googleSignInAccount.toString());
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    if (idToken != null) {
      final Map<String, dynamic> tokenData = {
        'idToken': idToken,
      };

      Response response = await post(
        AppUrl.google,
        body: json.encode(tokenData),
        headers: {'Content-Type': 'application/json'},
      );
      final String token = response.body;
      setSecureStorage("token", token);
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      return token;
    }
    return null;
  }

  Future<String> register(
      String email, String password, String username) async {
    final Map<String, dynamic> registrationData = {
      'email': email,
      'password': password,
      'username': username
    };
    final Response response = await post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'});
    setSecureStorage("token", response.body);
    return response.body;
  }

  Future<void> logout() async {
    this.deleteAll();
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
  }

//
//   static Future<FutureOr> onValue(Response response) async {
//     var result;
//     final Map<String, dynamic> responseData = json.decode(response.body);
//
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       var userData = responseData['data'];
//
//
//       result = {
//         'status': true,
//         'message': 'Successfully registered',
//
//       };
//     } else {
// //      if (response.statusCode == 401) Get.toNamed("/login");
//       result = {
//         'status': false,
//         'message': 'Registration failed',
//         'data': responseData
//       };
//     }
//
//     return result;
//   }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
