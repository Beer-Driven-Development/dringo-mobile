import 'package:dringo/domain/category.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/providers/auth.dart';
import 'package:dringo/providers/category_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/util/colors_palette.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:dringo/util/validators.dart';
import 'package:dringo/util/widgets.dart';
import 'package:dringo/widgets/app_divider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomCategories extends StatefulWidget {
  static const routeName = '/create-room-2';

  @override
  _CreateRoomCategoriesState createState() => _CreateRoomCategoriesState();
}

class _CreateRoomCategoriesState extends State<CreateRoomCategories> {
  final formKey = new GlobalKey<FormState>();
  var dropdownValue = category.categories.first;


  @override
  Widget build(BuildContext context) {
    CategoryProvider category = Provider.of<CategoryProvider>(context);


    var categoriesListDropdown = DropdownButton<Category>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (var newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: category.categories.map<DropdownMenuItem<Category>>((var value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.name.toString()),
        );
      }).toList(),
    );


    var createRoom= () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        // auth.register(_name, _passcode).then((response) {
        //   if (response.isNotEmpty) {
        //     User user = User.fromToken(response);
        //     Provider.of<UserProvider>(context, listen: false).setUser(user);
        //     Navigator.pushReplacementNamed(context, DashBoard.routeName);
        //   } else {
        //     Flushbar(
        //       title: "Registration Failed",
        //       message: response.toString(),
        //       duration: Duration(seconds: 10),
        //     ).show(context);
        //   }
        // });
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 135.0),
                  Text(
                    'Create room',
                    style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display'),
                  ),
                  SizedBox(height: 30.0),

                  categoriesListDropdown,

                  SizedBox(height: 40.0),
                  Center(
                    child: RaisedButton(
                      elevation: 10,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0)),
                      child: Text(
                          'Next'.toUpperCase(),
                          style: TextStyle(fontSize: 18.0, color: Colors.indigoAccent)
                      ),
                      onPressed: createRoom,
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
