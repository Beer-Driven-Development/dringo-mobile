class User {
  int userId;
  String name;
  String email;
  String phone;
  String type;
  String token;
  String renewalToken;

  User(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.type,
      this.token,
      this.renewalToken});

  factory User.fromToken(String token) {
    return User(
      token: token,
    );
  }

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      token: responseData['access_token'],
    );
  }
}
