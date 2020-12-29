import 'package:dringo/services/stream_socket.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  static const routeName = '/statistics';
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (context, snapshot) {
            return Text(snapshot.data.toString());
          },
        ),
      ),
    );
  }
}
