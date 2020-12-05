import 'package:dringo/domain/user.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    _user = new User.fromToken(token, decodedToken);
    notifyListeners();
  }

  void removeUser(User user) {
    _user = new User();
    notifyListeners();
  }
}
