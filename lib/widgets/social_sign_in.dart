import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SocialSignIn extends StatelessWidget {
  Widget _facebookButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        child: FlatButton(
            child: FaIcon(
              FontAwesomeIcons.facebookF,
              color: Colors.blue[800],
              size: 36.0,
            ),
            onPressed: () async {
              var token =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .facebook();
              if (token != null)
                Navigator.of(context).pushNamed(DashBoard.routeName);
            }),
      ),
    );
  }

  Widget _googleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        child: FlatButton(
            child: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.redAccent,
              size: 36.0,
            ),
            onPressed: () async {
              var token =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .google();
              if (token != null)
                Navigator.of(context).pushNamed(DashBoard.routeName);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _facebookButton(context),
          _googleButton(context),
        ],
      ),
    );
  }
}
