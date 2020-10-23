import 'dart:async';
import 'dart:io';

import 'package:dringo/helpers/jwt_decoder.dart';
import 'package:dringo/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _token;
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;
  String _email;
  String _username;

  String get email {
    return _email;
  }

  String get artistName {
    return _username;
  }

  Map<String, dynamic> _decodedToken;

  bool get isAuth {
    return token != null;
  }

  set isAuth(bool state) {
    isAuth = state;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  int get userId {
    return _userId;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await dio
          .post("auth/login", data: {'email': email, 'password': password});
      setPrefs(response.data);
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(String email, String password, String username) async {
    try {
      final response = await dio.post('auth/register',
          data: {"email": email, "password": password, "username": username});
      setPrefs(response.data);
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    if (token == null) {
      return false;
    }

    final expiryDate = DateTime.parse(prefs.getString('expiryDate'));

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = token;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    prefs.clear();
    notifyListeners();
  }

  void setPrefs(dynamic response) async {
    if (response['error'] != null) {
      throw HttpException(response['error']['message']);
    }
    _token = response['token'];
    _userId = response['id'];
    _decodedToken = JwtDecoder.tryParseJwt(_token);
    _email = response['email'];
    _username = response['username'];
    var values = _decodedToken.values.toList();
    var expiresIn = values[2] - values[1];

    _expiryDate = DateTime.now().add(
      Duration(
        seconds: expiresIn,
      ),
    );
    final SharedPreferences prefs = await _prefs;

    prefs.setString('token', _token);
    prefs.setString('expiryDate', _expiryDate.toIso8601String());
    prefs.setString('email', _email);
    prefs.setString('username', _username);
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
