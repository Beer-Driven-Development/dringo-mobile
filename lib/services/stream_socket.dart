import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StreamSocket {
  final _socketResponse = new BehaviorSubject(sync: true);

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
    _socketResponse.sink.close();
  }
}

StreamSocket streamSocket = StreamSocket();
