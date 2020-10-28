import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/register.dart';
import 'package:dringo/providers/user_provider.dart';
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

class _LoginState extends State<Login> {
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
      style: TextStyle(fontSize: 18.0),
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    var signUpLabel = Center(
      child: FlatButton(
        child: Text("No account? Sign up instead!",
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
        onPressed: () {
          UserPreferences().removeUser();
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
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            if (user != null)
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffa99164),
        body: Container(
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
                          color: Colors.black,
                          fontSize: 64.0,
                          letterSpacing: 1.2),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  usernameField,
                  SizedBox(height: 30.0),
                  passwordField,
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
                              'Sign in'.toUpperCase(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                            onPressed: doLogin,
                          ),
                        ),
                  SizedBox(height: 20.0),
                  AppDivider(),
                  SocialSignIn(),
                  SizedBox(height: 50.0),
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
