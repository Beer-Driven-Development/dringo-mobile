import 'package:dringo/domain/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(String token) {
    _user = new User.fromToken(token);
    notifyListeners();
  }

  void removeUser(User user) {
    _user = new User();
    notifyListeners();
  }
}
