import 'package:dringo/pages/create_room/create_room_categories.dart';
import 'package:dringo/providers/auth.dart';
import 'package:dringo/providers/category_provider.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/util/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomNamePasscode extends StatefulWidget {
  static const routeName = '/create-room-1';

  @override
  _CreateRoomNamePasscodeState createState() => _CreateRoomNamePasscodeState();
}

class _CreateRoomNamePasscodeState extends State<CreateRoomNamePasscode> {
  final formKey = new GlobalKey<FormState>();

  String _name, _passcode;

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final nameField = TextFormField(
      cursorColor: Colors.indigo,
      style: TextStyle(fontSize: 18.0, color: Colors.black54),
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please enter name of room" : null,
      onChanged: (value) => _name = value,
      decoration: buildInputDecoration("Name", Icons.meeting_room),
    );

    final passcodeField = TextFormField(
      cursorColor: Colors.indigo,
      style: TextStyle(fontSize: 18.0, color: Colors.black54),
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter passcode" : null,
      onChanged: (value) => _passcode = value,
      decoration: buildInputDecoration('Passcode', Icons.lock),
    );

    var createRoom = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 135.0),
                  Text(
                    'Create room',
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display'),
                  ),
                  SizedBox(height: 30.0),
                  nameField,
                  SizedBox(height: 30.0),
                  passcodeField,
                  SizedBox(height: 40.0),
                  Center(
                    child: RaisedButton(
                      elevation: 10,
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0)),
                      child: Text('Next'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.indigoAccent)),
                      onPressed: () async {
                        var room;
                        try {
                          room = await Provider.of<RoomProvider>(context,
                                  listen: false)
                              .createRoom(_name, _passcode);
                        } catch (error) {
                          throw error;
                        }

                        Navigator.pushNamed(
                            context, CreateRoomCategories.routeName,
                            arguments: room.id);
                      },
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
