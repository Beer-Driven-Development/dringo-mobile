import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/pages/room.dart' as RoomPage;
import 'package:dringo/services/socket_service.dart';
import 'package:dringo/util/widgets.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RoomItem extends StatelessWidget with SecureStorageMixin {
  final Room room;
  RoomItem({this.room});

  @override
  Widget build(BuildContext context) {
    final SocketService socketService = injector.get<SocketService>();
    socketService.createSocketConnection();

    Future _asyncInputDialog(BuildContext context, int id) async {
      String passcode = '';
      final token = await getSecureStorage("token");

      return showDialog(
        context: context,
        barrierDismissible:
            false, // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Enter passcode', style: TextStyle(color: Colors.indigo)),
            content: new Row(
              children: [
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration:
                      buildInputDecoration('Enter room passcode', Icons.lock),
                  onChanged: (value) {
                    passcode = value;
                  },
                ))
              ],
            ),
            actions: [
              FlatButton(
                child: Text(
                  'Enter',
                  style: TextStyle(color: Colors.indigo),
                ),
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

    Size deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        await _asyncInputDialog(context, room.id);
      },
      child: Container(
        height: deviceSize.height * 0.09,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD1DCFF),
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: Icon(
                      Icons.sports_bar_sharp,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.only(left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          room.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          room.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.indigo,
              )
            ],
          ),
        ),
      ),
    );
  }
}
