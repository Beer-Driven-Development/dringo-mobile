import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialSignIn extends StatelessWidget {
  Widget _facebookButton() {
    return Container(
      height: 100,
      width: 75,
      child: IconButton(
          iconSize: 36.0,
          icon: FaIcon(
            FontAwesomeIcons.facebookF,
            color: Colors.blue[700],
          ),
          onPressed: null),
    );
  }

  Widget _googleButton() {
    return Container(
      height: 100,
      width: 75,
      child: IconButton(
        iconSize: 36.0,
        icon: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.red[700],
        ),
        onPressed: null,
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
          _googleButton(),
        ],
      ),
    );
  }
}
