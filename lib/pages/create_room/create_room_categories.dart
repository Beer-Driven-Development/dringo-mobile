import 'package:dringo/domain/category.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/domain/value_object.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomCategories extends StatefulWidget {
  static const routeName = '/create-room-2';

  @override
  _CreateRoomCategoriesState createState() => _CreateRoomCategoriesState();
}

class _CreateRoomCategoriesState extends State<CreateRoomCategories> {
  final formKey = new GlobalKey<FormState>();
  var categories;
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  List<DropdownMenuItem<ValueObject>> _dropdownMenuItemsValueObject;
  Category _selectedCategory;
  ValueObject _selectedValueObject;

  List<ValueObject> _dropdownItems = [
    ValueObject(id: 1, value: "1"),
    ValueObject(id: 2, value: "2"),
    ValueObject(id: 3, value: "3"),
    ValueObject(id: 4, value: "4"),
    ValueObject(id: 5, value: "5"),
  ];

 _addCategory(int id, int weight )
 {

 }



  @override
  void initState() {
    categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    _dropdownMenuItems = buildDropDownMenuItems(categories);
    _selectedCategory = _dropdownMenuItems[0].value;
    _dropdownMenuItemsValueObject = buildDropDownMenuItemsValueObject(_dropdownItems);
    _selectedValueObject =  _dropdownMenuItemsValueObject[0].value;


    super.initState();
  }

  List<DropdownMenuItem<Category>> buildDropDownMenuItems(List listCategories) {
    List<DropdownMenuItem<Category>> categories = List();
    for (Category category in listCategories) {
      categories.add(
        DropdownMenuItem(
          child: Text(category.name),
          value: category,
        ),
      );
    }
    return categories;
  }


  List<DropdownMenuItem<ValueObject>> buildDropDownMenuItemsValueObject(List listItems) {
    List<DropdownMenuItem<ValueObject>> items = List();
    for (ValueObject listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.value),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var createRoom = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
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
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(ColorsPalette.secondaryColor),
            Color(ColorsPalette.primaryColor)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 135.0),
                  Text(
                    'Choose category and weight',
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display'),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisSize: MainAxisSize.min, // see 3
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: DropdownButton<Category>( isExpanded: true,
                              value: _selectedCategory,
                              selectedItemBuilder: (BuildContext context) {
                                return categories.map<Widget>((Category category) {
                                  return Text(category.name, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.white), softWrap: true, );
                                }).toList();
                              },
                              items: _dropdownMenuItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: DropdownButton<ValueObject>(
                              value:  _selectedValueObject,

                              selectedItemBuilder: (BuildContext context) {
                                return _dropdownItems.map<Widget>((ValueObject vo) {
                                  return Text(vo.value, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.white), softWrap: false, );
                                }).toList();
                              },
                              items: _dropdownMenuItemsValueObject,
                              onChanged: (value) {
                                setState(() {
                                  _selectedValueObject = value;
                                });
                              }),
                        ),
                      ),
                      Flexible(child: IconButton(icon: Icon(Icons.add), color:Colors.white, onPressed: (){
                        _addCategory(_selectedCategory.id, _selectedValueObject.id);
                      }))
                    ],
                  ),
                  SizedBox(height: 120.0),
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
