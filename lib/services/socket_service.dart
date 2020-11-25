import 'dart:async';

import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket socket;
  var data = 'kurde faja';
  var _socketResponse = new BehaviorSubject<String>();

  Sink<String> get sink => _socketResponse.sink;

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    super.dispose();
    _socketResponse.close();
    _socketResponse = StreamController<String>();
  }

  createSocketConnection() {
    socket = IO.io(AppUrl.baseURL, <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on("connect", (data) => _socketResponse.sink.add(data));
    this.socket.on("disconnect", (data) => _socketResponse.sink.add(data));
    this.socket.on('joinedRoom', (data) => _socketResponse.sink.add(data));
    this.socket.on('accessDenied', (data) => _socketResponse.sink.add(data));
    this.socket.on('userLeft', (data) => _socketResponse.sink.add(data));
  }

  Future<bool> leaveRoom(String event, message) async {
    sendMessage(event, message);
    return true;
  }

  sendMessage(String event, message) {
    this.socket.emit(event, message);
  }

  response(data) {
    this.data = data;
    notifyListeners();
  }
}
