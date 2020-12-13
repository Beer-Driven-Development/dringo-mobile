import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier, SecureStorageMixin {
  User _user = new User();

  User get user => _user;

  void setUser(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    _user = new User.fromToken(token, decodedToken);
    notifyListeners();
  }

  Future<User> getUser() async {
    final token = await getSecureStorage('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    _user = new User.fromToken(token, decodedToken);
    notifyListeners();
    return _user;
  }

  void removeUser(User user) {
    _user = new User();
    notifyListeners();
  }
}
