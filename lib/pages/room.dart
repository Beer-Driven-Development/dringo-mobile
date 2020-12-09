import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Room extends StatefulWidget {
  static const routeName = '/room';

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> with SecureStorageMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
    final SocketService socketService = injector.get<SocketService>();
    void dispose() {
      super.dispose();
    }

    var participants = new List<String>();

    final user = Provider.of<UserProvider>(context, listen: false).user;

    final room = Provider.of<RoomProvider>(
      context,
      listen: false,
    ).findById(id);

    return StreamBuilder(
      stream: socketService.getResponse,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) participants.add(snapshot.data.toString());

        return WillPopScope(
          onWillPop: () async {
            final token = await getSecureStorage("token");
            var message = new MessageModel().fromIdToJson(token.toString(), id);
            return await socketService.leaveRoom('leaveRoom', message);
          },
          child: Scaffold(
            body: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70.0),
                    Center(
                      child: Text(
                        room.name,
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    for (var participant in participants)
                      Text(
                        participant,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    SizedBox(height: 30.0),
                    if (room.creator.id == user.id)
                      RaisedButton(
                          child: Text("Start".toUpperCase()), onPressed: () {})
                  ]),
            ),
          ),
        );
      },
    );
  }
}
