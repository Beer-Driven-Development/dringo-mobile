import 'dart:async';

class StreamSocket {
  final _socketResponse = StreamController<dynamic>.broadcast();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
    _socketResponse.sink.close();
  }
}

StreamSocket streamSocket = StreamSocket();
