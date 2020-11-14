import 'dart:convert';

import 'package:dringo/domain/room.dart';
import 'package:dringo/util/app_url.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RoomProvider with ChangeNotifier {
  List<Room> _rooms = [];

  List<Room> get rooms {
    return [..._rooms];
  }

  Future<void> getAll() async {
    final token = await UserPreferences().getToken();

    final response = await get(
      AppUrl.rooms,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      final List<Room> rooms = [];
      for (var room in responseData) {
        rooms.add(Room.fromJson(room));
      }

      _rooms = rooms;
      notifyListeners();
    }
  }

  Room findById(int id) {
    return _rooms.firstWhere((room) => room.id == id);
  }

  // Future<void> enter(int id, String passcode) async {
  //   final token = await UserPreferences().getToken();
  //   var data = {
  //     "data": {"id": id, "passcode": passcode, "token": token}
  //   };
  //   IO.Socket socket = IO.io(AppUrl.baseURL, <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });
  //   socket.connect();
  //   socket.emit('joinRoom', data);
  //   socket.on('joinedRoom', (data) => log(data));
  //   socket.on('accessDenied', (data) => log(data));
  //   notifyListeners();
  // }

}
