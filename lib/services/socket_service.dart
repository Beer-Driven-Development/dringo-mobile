import 'dart:async';

import 'package:dringo/util/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket socket;
  var data = 'kurde faja';
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  createSocketConnection() {
    socket = IO.io(AppUrl.baseURL, <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on("connect", (_) => addResponse('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
    this.socket.on('joinedRoom', (data) => addResponse(data));
  }

  sendMessage(String event, message) {
    this.socket.emit(event, message);
  }

  response(data) {
    this.data = data;
    notifyListeners();
  }
}
