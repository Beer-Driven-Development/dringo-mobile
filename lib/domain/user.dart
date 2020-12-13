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

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "username": this.username,
      "email": this.email,
    };
  }

  static List<User> getParticipants(dynamic data) {
    List<User> participants =
        List<User>.from(data.map((u) => User.fromJson(u)));
    return participants;
  }
}
