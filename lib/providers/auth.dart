import 'dart:async';
import 'dart:convert';

import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/util/app_url.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:flutter/material.dart';
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

      result = {'status': true, 'message': 'Successful'};
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
    UserPreferences().removeUser();
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
