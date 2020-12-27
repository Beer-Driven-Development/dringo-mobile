import 'dart:collection';

import 'package:dringo/domain/degustation_data.dart';
import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/main.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/stream_socket.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'degustation.dart';

class Room extends StatefulWidget {
  static const routeName = '/room';

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> with SecureStorageMixin {
  var user;

  @override
  void initState() {
    super.initState();
  }

  void getUser() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
    getUser();
    // final SocketService socketService = injector.get<SocketService>();
    void dispose() {
      super.dispose();
    }

    var map = new LinkedHashMap<String, List<User>>();
    var participants = new List<User>();

    final room = Provider.of<RoomProvider>(
      context,
      listen: false,
    ).findById(id);

    return StreamBuilder(
      stream: streamSocket.getResponse,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data['beer'] != null) {
          Future.microtask(() => Navigator.of(context).pushNamed(
              Degustation.routeName,
              arguments: DegustationData(
                  room, snapshot.data['beer'], snapshot.data['pivots'])));
        } else {
          map = snapshot.data;
        }
        if (map.containsKey(room.id.toString())) {
          participants = map.values.first.toList();
        }

        return WillPopScope(
          onWillPop: () async {
            final token = await getSecureStorage("token");
            var message = new MessageModel().fromIdToJson(token.toString(), id);
            emit('leaveRoom', message);
            return true;
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
                            fontWeight: FontWeight.w900,
                            color: Colors.indigo),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    Text(
                      'List of participants',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo,
                          fontSize: 24.0),
                    ),
                    SizedBox(height: 20.0),
                    for (var participant in participants)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (participant.id == room.creator.id)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.crown,
                                color: Colors.indigo,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              participant.username,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 70.0),
                    if (user != null && room.creator.id == user.id)
                      Center(
                        child: RaisedButton(
                          elevation: 10,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0)),
                          child: Text(
                            'Start'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.indigoAccent),
                          ),
                          onPressed: () async {
                            await Provider.of<DegustationProvider>(context,
                                    listen: false)
                                .start(room.id, participants);
                            var beers = Provider.of<DegustationProvider>(
                                    context,
                                    listen: false)
                                .beers;
                            var pivots = Provider.of<DegustationProvider>(
                                    context,
                                    listen: false)
                                .pivots;
                            if (beers.isNotEmpty && pivots.isNotEmpty) {
                              final token = await getSecureStorage("token");
                              var message = new MessageModel()
                                  .fromIdToJson(token.toString(), id);

                              emit('getDegustation', message);
                              // emit('next', beers.first.id);
                            }
                          },
                        ),
                      ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
