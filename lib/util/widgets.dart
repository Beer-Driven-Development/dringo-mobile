import 'package:flutter/material.dart';

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    errorStyle: TextStyle(fontSize: 14.0, color: Colors.red[900]),
    labelStyle: TextStyle(color: Colors.indigo),
    labelText: hintText,
    prefixIcon: Icon(icon, color: Colors.indigo),
    filled: true,
    fillColor: Colors.white,
    // hintText: hintText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.4),
      borderRadius: BorderRadius.circular(100.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[900], width: 1.4),
      borderRadius: BorderRadius.circular(100.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.indigo, width: 1.4),
      borderRadius: BorderRadius.circular(100.0),
    ),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(50, 62, 72, 1.0), width: 1.4),
      borderRadius: BorderRadius.circular(100.0),
    ),
  );
}
