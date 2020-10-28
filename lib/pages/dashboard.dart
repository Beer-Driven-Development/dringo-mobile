import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/home';

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(child: Text(user.token != null ? user.token : '')),
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
}
