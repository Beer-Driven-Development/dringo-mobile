import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:dringo/util/validators.dart';
import 'package:dringo/util/widgets.dart';
import 'package:dringo/widgets/app_divider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'login.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _email, _password, _username;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      style: TextStyle(fontSize: 18.0),
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Email", Icons.email),
    );

    final passwordField = TextFormField(
      style: TextStyle(fontSize: 18.0),
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    final usernameField = TextFormField(
      style: TextStyle(fontSize: 18.0),
      autofocus: false,
      validator: (value) => value.isEmpty ? "Username is required" : null,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Username", Icons.person),
    );

    var signInLabel = Center(
      child: FlatButton(
        child: Text("Have an account? Sign in instead!",
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
        onPressed: () {
          UserPreferences().removeUser();
          Navigator.pushReplacementNamed(context, Login.routeName);
        },
      ),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering... Please wait")
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth.register(_email, _password, _username).then((response) {
          if (response.isNotEmpty) {
            User user = User.fromToken(response);
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, DashBoard.routeName);
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffa99164),
        body: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    'Fill this sign up form',
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display'),
                  ),
                  SizedBox(height: 30.0),
                  emailField,
                  SizedBox(height: 30.0),
                  passwordField,
                  SizedBox(height: 30.0),
                  usernameField,
                  SizedBox(height: 30.0),
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
                              'Sign up'.toUpperCase(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            onPressed: doRegister,
                          ),
                        ),
                  AppDivider(),
                  signInLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
