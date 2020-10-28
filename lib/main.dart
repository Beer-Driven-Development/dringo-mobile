import 'package:dringo/pages/login.dart';
import 'package:dringo/pages/welcome.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';
import 'providers/auth.dart';
import 'routes.dart';

void main() {
  runApp(Dringo());
}

class Dringo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Dringo',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Poppins'),
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
                    else if (snapshot.data.token == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return Welcome(user: snapshot.data);
                }
              }),
          routes: routes),
    );
  }
}
