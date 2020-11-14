import 'dart:async';

import 'package:dringo/util/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket socket;
  var data = 'kurde faja';
  var _socketResponse = new BehaviorSubject<List<String>>();

  Sink<List<String>> get sink => _socketResponse.sink;

  void Function(List<String>) get addResponse => _socketResponse.sink.add;

  Stream<List<String>> get getResponse => _socketResponse.stream;

  void dispose() {
    super.dispose();
    _socketResponse.close();
    _socketResponse = StreamController<List<String>>();
  }

  createSocketConnection() {
    socket = IO.io(AppUrl.baseURL, <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on(
        "connect", (data) => _socketResponse.sink.add(new List()..add(data)));
    this.socket.on("disconnect",
        (data) => _socketResponse.sink.add(new List()..add(data)));
    this.socket.on('joinedRoom',
        (data) => _socketResponse.sink.add(new List()..add(data)));
  }

  sendMessage(String event, message) {
    this.socket.emit(event, message);
  }

  response(data) {
    this.data = data;
    notifyListeners();
  }
}
