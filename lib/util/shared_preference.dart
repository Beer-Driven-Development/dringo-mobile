import 'dart:async';

import 'package:dringo/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token", user.token);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");

    return User(
      token: token,
    );
  }

  Future<bool> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    return prefs.commit();
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
