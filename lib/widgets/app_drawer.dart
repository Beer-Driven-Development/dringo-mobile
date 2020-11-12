import 'package:dringo/pages/login.dart';
import 'package:dringo/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello there!',
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () => {
                    Provider.of<AuthProvider>(context, listen: false).logout(),
                    Navigator.pushReplacementNamed(context, Login.routeName)
                  })
        ],
      ),
    );
  }
}
