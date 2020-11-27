import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/providers/category_provider.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/app_initializer.dart';
import 'package:dringo/services/dependency_injection.dart';
import 'package:dringo/services/socket_service.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';
import 'providers/auth.dart';
import 'routes.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector);
  runApp(Dringo());
}

class Dringo extends StatefulWidget  {
  @override
  _DringoState createState() => _DringoState();
}

class _DringoState extends State<Dringo> with SecureStorageMixin{
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
                    else if (snapshot.data== null)
                      return Login();
                    return DashBoard(
                      token: snapshot.data,
                    );
                }
              }),
          routes: routes),
    );
  }
}
