import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SocialSignIn extends StatelessWidget {
  Widget _facebookButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(180.0), color: Colors.white),
        child: IconButton(
            iconSize: 36.0,
            icon: FaIcon(
              FontAwesomeIcons.facebookF,
              color: Colors.blue[700],
            ),
            onPressed: null),
      ),
    );
  }

  Widget _googleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(180.0), color: Colors.white),
        child: IconButton(
            iconSize: 36.0,
            icon: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red[700],
            ),
            onPressed: () async {
              var token =
                  Provider.of<AuthProvider>(context, listen: false).google();
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
          _facebookButton(),
          _googleButton(context),
        ],
      ),
    );
  }
}
