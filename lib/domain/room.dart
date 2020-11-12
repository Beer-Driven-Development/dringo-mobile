import 'package:dringo/domain/user.dart';
import 'package:flutter/material.dart';

class Room with ChangeNotifier {
  int id;
  String name;
  DateTime createdAt;
  DateTime startedAt;
  DateTime finishedAt;
  User creator;
  List<User> participants;

  Room(
      {@required this.id,
      @required this.name,
      this.createdAt,
      this.startedAt,
      this.finishedAt,
      this.creator,
      this.participants});

  factory Room.fromJson(Map<String, dynamic> responseData) {
    return Room(
      id: responseData['id'],
      name: responseData['name'],
    );
  }
}
