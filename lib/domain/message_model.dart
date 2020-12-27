class MessageModel {
  String token;
  int roomId;
  String data;
  String passcode;

  MessageModel({this.token, this.roomId, this.data});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        data: json['data'],
      );

  Map<String, dynamic> toJson(String token, int roomId, String passcode) =>
      {"token": token, 'id': roomId, 'passcode': passcode};

  Map<String, dynamic> fromIdToJson(String token, int roomId) =>
      {"token": token, 'id': roomId};

  Map<String, dynamic> fromDataToJson(String token, int roomId, int beerId) =>
      {"token": token, 'roomId': roomId, 'beerId': beerId};
}
