import 'dart:io';

import 'package:dringo/providers/auth.dart';
import 'package:dringo/widgets/social_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RegisterScreen.dart';

String emailFieldValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? 'Not a valid email' : null;
}

class PasswordFieldValidator {
  static String validate(String value) {
    return (value.isEmpty || value.length < 8) ? 'Password is too short' : null;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  var _email;
  var _password;

  Future<void> _submit() async {
    try {
      await Provider.of<Auth>(context, listen: false).login(_email, _password);
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";

      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      'Dringo',
      style: TextStyle(
          fontSize: 50, fontWeight: FontWeight.w900, color: Colors.blue),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: isPassword == false
                ? TextInputType.emailAddress
                : TextInputType.text,
            validator: isPassword == true
                ? PasswordFieldValidator.validate
                : emailFieldValidator,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            onChanged: (String value) {
              isPassword == true ? _password = value : _email = value;
            },
            onSaved: (String value) {
              isPassword == true ? _password = value : _email = value;
            },
          )
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: RaisedButton(
        color: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)),
        onPressed: () {
          _submit();
        },
        child: Text(
          'Sign In'.toUpperCase(),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _signUpRedirection() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: FlatButton(
        color: Colors.transparent,
        child: Text(
          'No account? Sign Up!',
          style: TextStyle(
              color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.w700),
        ),
        onPressed: () =>
            Navigator.of(context).pushNamed(RegisterScreen.routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  _title(),
                  SizedBox(
                    height: 50,
                  ),
                  _emailPasswordWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ),
                  SocialLogin(),
                  SizedBox(
                    height: 10,
                  ),
                  _signUpRedirection(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
