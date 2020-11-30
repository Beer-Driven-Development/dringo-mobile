import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialSignIn extends StatelessWidget {
  Widget _facebookButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(180.0), color: Colors.white),
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

  Widget _googleButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(180.0), color: Colors.white),
        child: IconButton(
          iconSize: 36.0,
        icon: FaIcon(
            FontAwesomeIcons.google,
            color: Colors.red[700],
          ),
          onPressed: (){
            GoogleSignIn(clientId: '409741835950-3rt0ud59v317lrsrphiakrdpfrt965q5.apps.googleusercontent.com').signIn();
          }
        ),
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
