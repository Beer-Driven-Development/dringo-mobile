import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/pages/room.dart' as RoomPage;
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/services/socket_service.dart';
import 'package:dringo/widgets/room_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class RoomsList extends StatelessWidget with SecureStorageMixin {
  RoomsList();

  @override
  Widget build(BuildContext context) {
    final SocketService socketService = injector.get<SocketService>();
    socketService.createSocketConnection();

    final roomsData = Provider.of<RoomProvider>(context);
    final rooms = roomsData.rooms;
    Future _asyncInputDialog(BuildContext context, int id) async {
      String passcode = '';
      final token = await getSecureStorage("token");

      return showDialog(
        context: context,
        barrierDismissible:
            false, // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter passcode'),
            content: new Row(
              children: [
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Passcode', hintText: 'Enter room passcode'),
                  onChanged: (value) {
                    passcode = value;
                  },
                ))
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Enter'),
                onPressed: () async {
                  // final SocketService socketService =
                  //     injector.get<SocketService>();
                  // socketService.createSocketConnection();
                  // socketService.enter(id, passcode);

                  var message = new MessageModel().toJson(token, id, passcode);
                  socketService.sendMessage('joinRoom', message);
                  Navigator.pushNamed(context, RoomPage.Room.routeName,
                      arguments: id);
                },
              ),
            ],
          );
        },
      );
    }

    ListTile makeListTile(Room room) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          room.name,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          await _asyncInputDialog(context, room.id);
        });

    RoomItem makeCard(Room room) => RoomItem(room: room);

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: rooms.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: rooms[i],
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: makeCard(rooms[i]),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );
  }
}
