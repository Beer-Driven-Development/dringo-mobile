import 'package:dringo/domain/room.dart';
import 'package:flutter/material.dart';

class Beer with ChangeNotifier {
  int id;
  String name;
  double abv;
  Room room;
  int roomId;

  Beer(
      {this.id,
      @required this.name,
      @required this.abv,
      this.room,
      this.roomId});

  factory Beer.fromJson(Map<String, dynamic> responseData) {
    return Beer(
        id: responseData['id'],
        name: responseData['name'],
        abv: double.parse(responseData['abv'].toString()),
        room: Room.fromJson(responseData['room']));
  }
}
