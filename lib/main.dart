import 'dart:async';
import 'dart:collection';

import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/providers/beer_provider.dart';
import 'package:dringo/providers/category_provider.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/socket_service.dart';
import 'package:dringo/services/stream_socket.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'domain/beer.dart';
import 'domain/pivot.dart';
import 'providers/auth.dart';
import 'routes.dart';

Injector injector;
IO.Socket socket = IO.io(
    AppUrl.baseURL, IO.OptionBuilder().setTransports(['websocket']).build());

List<String> roomsId = [];

void emit(String event, message) {
  socket.emit(event, message);
}

Future<List<String>> getAccessedRooms() async {
  return roomsId;
}

void main() async {
  // DependencyInjection().initialise(Injector());
  // injector = Injector();
  // await AppInitializer().initialise(injector);
  onMessageReceived(LinkedHashMap<String, dynamic> data) {
    String roomId = data['room'];
    List<dynamic> usersData = data['users'];
    List<User> users = new List<User>();
    usersData.forEach((user) {
      User userToAdd = User.fromJson(user);
      users.add(userToAdd);
    });
    Map<String, List<User>> response = new LinkedHashMap<String, List<User>>();
    response[roomId] = users;
    // users.forEach((user) {
    //   streamSocket.addResponse(user);
    // });
    streamSocket.addResponse(response);
  }

  onDegustationReceived(LinkedHashMap<String, dynamic> degustation) {
    if (degustation['status'] == 400) {
      streamSocket.addResponse(degustation['status']);
    } else {
      var beerData = degustation['beer'];
      List<dynamic> pivotsData = degustation['pivots'];

      Beer beer = new Beer.fromJson(beerData);
      List<Pivot> pivots = new List<Pivot>();

      pivotsData.forEach((pivot) {
        Pivot pivotToAdd = Pivot.fromJson(pivot);
        pivots.add(pivotToAdd);
      });

      final Map<String, dynamic> data = {'beer': beer, 'pivots': pivots};

      streamSocket.addResponse(data);
    }
  }

  onRoomJoined(String roomId) {
    if (roomId != null) roomsId.add(roomId);
  }

  socket.on('usersList', (data) => onMessageReceived(data));
  socket.on('joinedRoom', (data) => onRoomJoined(data));

  socket.on('degustation', (data) => onDegustationReceived(data));
  socket.on('first', (data) => onDegustationReceived(data));
  socket.on('next', (data) => onDegustationReceived(data));
  socket.on('stats', (data) => streamSocket.addResponse(data));

  socket.onDisconnect((_) => print('disconnect'));

  runApp(Dringo());
}

class Dringo extends StatefulWidget {
  @override
  _DringoState createState() => _DringoState();
}

class _DringoState extends State<Dringo> with SecureStorageMixin {
  bool _connectedToSocket;
  String _errorConnectMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> getUserData() => this.getSecureStorage("token");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BeerProvider()),
        ChangeNotifierProvider(create: (_) => DegustationProvider()),
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
          title: 'Dringo',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Poppins'),
          color: Colors.white,
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data == null) return Login();
                    return DashBoard(
                      token: snapshot.data,
                    );
                }
              }),
          routes: routes),
    );
  }
}
