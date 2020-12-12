import 'dart:async';
import 'dart:collection';

import 'package:dringo/domain/user.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket socket;
  var data;
  var _socketResponse = new BehaviorSubject();

  Sink<dynamic> get sink => _socketResponse.sink;

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    super.dispose();
    _socketResponse.close();
    _socketResponse = StreamController<dynamic>();
  }

  createSocketConnection() {
    socket = IO.io(AppUrl.baseURL, <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on("connect", (data) => onMessageReceived(data));
    this.socket.on("disconnect", (data) => onMessageReceived(data));
    this.socket.on('usersList', (data) => onMessageReceived(data));
    this.socket.on('accessDenied', (data) => onMessageReceived(data));
  }

  Future<bool> leaveRoom(String event, message) async {
    sendMessage(event, message);
    return true;
  }

  onMessageReceived(LinkedHashMap<String, dynamic> data) {
    String roomId = data['room'];
    List<User> users = data.values.first;
    users.forEach((user) {
      _socketResponse.sink.add(user);
    });
  }

  sendMessage(String event, message) {
    this.socket.emit(event, message);
    notifyListeners();
  }

  response(data) {
    this.data = data;
    notifyListeners();
  }
}
