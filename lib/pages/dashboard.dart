import 'dart:convert';

import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../providers/auth.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/home';

  final User user;
  final WebSocketChannel channel;

  DashBoard({Key key, this.user, this.channel}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController _controller = TextEditingController();
  User user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(child: Text(user.token != null ? user.token : '')),
          SizedBox(height: 100),
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
          ),
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Login.routeName);
              Provider.of<UserProvider>(context, listen: false)
                  .removeUser(user);
              user = null;
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    Map<String, dynamic> joinRoom = {
      "event": "joinRoom",
      "data": [
        {"id": 1},
        {"token": user.token}
      ]
    };
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(json.encode(joinRoom));
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
