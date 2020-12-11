class User {
  int id;
  String username;
  String email;
  String token;

  User({
    this.id,
    this.username,
    this.email,
    this.token,
  });

  factory User.fromToken(
      String encodedToken, Map<String, dynamic> decodedToken) {
    return User(
        token: encodedToken,
        id: decodedToken["id"],
        email: decodedToken["email"],
        username: decodedToken["username"]);
  }

  factory User.fromJson(
    Map<String, dynamic> responseData,
  ) {
    return User(
        id: responseData["id"],
        email: responseData["email"],
        username: responseData["username"]);
  }
}
