import 'dart:ui';

import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/register.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/util/colors_palette.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:dringo/util/validators.dart';
import 'package:dringo/util/widgets.dart';
import 'package:dringo/widgets/app_divider.dart';
import 'package:dringo/widgets/social_sign_in.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      style: TextStyle(fontSize: 18.0, color: Colors.white),
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("E-mail", Icons.email),
    );

    final passwordField = TextFormField(
      style: TextStyle(fontSize: 18.0, color: Colors.white),
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
          child: CircularProgressIndicator(),
        ),
        Text(" Authenticating... Please wait", style: TextStyle(color: Colors.white))
      ],
    );

    var signUpLabel = Center(
      child: FlatButton(
        child: Text("No account? Sign up instead!",
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
        onPressed: () {
          Navigator.pushReplacementNamed(context, Register.routeName);
        },
      ),
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            String token = response['token'];
            Provider.of<UserProvider>(context, listen: false).setUser(token);
            if (token != null)
              Navigator.pushReplacementNamed(context, DashBoard.routeName);
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Container(
            constraints:BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(ColorsPalette.secondaryColor), Color(ColorsPalette.primaryColor) ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70.0),
                  Center(
                    child: Text(
                      'Dringo',
                      style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 64.0,
                          letterSpacing: 1.2),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  usernameField,
                  SizedBox(height: 30.0),
                  passwordField,
                  SizedBox(height: 50.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : Center(
                          child: RaisedButton(
                            elevation: 10,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0)),
                            child: Text(
                              'Sign in'.toUpperCase(),
                              style: TextStyle(fontSize: 18.0, color:Colors.indigoAccent),
                            ),
                            onPressed: doLogin,
                          ),
                        ),
                  SizedBox(height: 50.0),
                  AppDivider(),
                  SizedBox(height: 30.0),
                  SocialSignIn(),
                  SizedBox(height: 30.0),
                  signUpLabel,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
