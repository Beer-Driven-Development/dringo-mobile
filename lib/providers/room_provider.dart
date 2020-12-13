import 'dart:convert';

import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RoomProvider with ChangeNotifier, SecureStorageMixin {
  List<Room> _rooms = [];

  List<Room> get rooms {
    return [..._rooms];
  }

  Future<void> getAll() async {
    final token = await this.getSecureStorage("token");

    if (token == null) {
      return;
    }

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

  Future<void> changeStatus(int id) async {
    final token = await getSecureStorage("token");

    final response = await post(
      AppUrl.rooms + '/' + id.toString(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    notifyListeners();
  }

  Future<Room> createRoom(String name, String passcode) async {
    final Map<String, dynamic> roomData = {'name': name, 'passcode': passcode};

    final token = await getSecureStorage("token");

    final response = await post(
      AppUrl.rooms,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
      body: json.encode(roomData),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final room = Room.fromJson(responseData);

      return room;
    }
    throw new Exception('Bad Request');
  }

  Future<void> start(int roomId, List<User> participants) async {
    final token = await getSecureStorage("token");
    var encodedParticipants = new List<Map<String, dynamic>>();
    for (User participant in participants) {
      encodedParticipants.add(participant.toJson());
    }

    final Map<String, List<Map<String, dynamic>>> participantsData = {
      'participants': encodedParticipants
    };

    final response = await post(
      AppUrl.rooms + '/' + roomId.toString() + '/start',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
      body: json.encode(participantsData),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final room = Room.fromFullJson(responseData);

      return room;
    }
    throw new Exception('Bad Request');
  }
}
