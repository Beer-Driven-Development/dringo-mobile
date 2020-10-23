import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLogin extends StatelessWidget {
  Widget _facebookButton() {
    return Container(
      height: 100,
      width: 75,
      child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.facebookF,
            color: Colors.blue,
          ),
          onPressed: null),
    );
  }

  Widget _googleButton() {
    return Container(
      height: 100,
      width: 75,
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.google,
          color: Colors.red,
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
