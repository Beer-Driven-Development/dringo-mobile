import 'package:dringo/domain/category.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/value_object.dart';
import 'package:dringo/pages/create_room/create_room_beers.dart';
import 'package:dringo/providers/category_provider.dart';
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
  var categories;
  List<Pivot> pivots;
  int roomId;
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  List<DropdownMenuItem<ValueObject>> _dropdownMenuItemsValueObject;
  Category _selectedCategory;
  ValueObject _selectedValueObject;
  var _isInit = true;
  var _isButtonDisabled;

  List<ValueObject> _dropdownItems = [
    ValueObject(id: 1, value: "1"),
    ValueObject(id: 2, value: "2"),
    ValueObject(id: 3, value: "3"),
    ValueObject(id: 4, value: "4"),
    ValueObject(id: 5, value: "5"),
  ];

  _addCategory(int roomId, int id, int weight) {
    Provider.of<CategoryProvider>(context, listen: false)
        .addCategory(roomId, id, weight);
    setState(() {
      _isButtonDisabled = false;
    });
  }

  _deletePivot(int roomId, int pivotId) {
    Provider.of<CategoryProvider>(context, listen: false)
        .deletePivot(roomId, pivotId);
    if (pivots.isEmpty) {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  @override
  void initState() {
    pivots = [];
    _isButtonDisabled = true;
    categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    _dropdownMenuItems = buildDropDownMenuItems(categories);
    _selectedCategory = _dropdownMenuItems[0].value;
    _dropdownMenuItemsValueObject =
        buildDropDownMenuItemsValueObject(_dropdownItems);
    _selectedValueObject = _dropdownMenuItemsValueObject[0].value;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      roomId = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
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

  List<DropdownMenuItem<ValueObject>> buildDropDownMenuItemsValueObject(
      List listItems) {
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
    pivots = Provider.of<CategoryProvider>(context, listen: true)
            .pivots
            .where((pivot) => pivot.room.id == roomId)
            .toList() ??
        [];
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

    return WillPopScope(
      onWillPop: () async {
        pivots = [];
        Provider.of<CategoryProvider>(context, listen: false).deletePivots();
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.0),
                    Text(
                      'Choose category and weight',
                      style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.indigo,
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
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<Category>(
                                isExpanded: true,
                                value: _selectedCategory,
                                selectedItemBuilder: (BuildContext context) {
                                  return categories
                                      .map<Widget>((Category category) {
                                    return Text(
                                      category.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.indigo),
                                      softWrap: true,
                                    );
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
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<ValueObject>(
                                value: _selectedValueObject,
                                selectedItemBuilder: (BuildContext context) {
                                  return _dropdownItems
                                      .map<Widget>((ValueObject vo) {
                                    return Text(
                                      vo.value,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.indigo),
                                      softWrap: false,
                                    );
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
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Icon(Icons.add),
                                    color: Colors.indigo,
                                    onPressed: () {
                                      _addCategory(roomId, _selectedCategory.id,
                                          _selectedValueObject.id);
                                    })))
                      ],
                    ),
                    Consumer<CategoryProvider>(
                      builder: (context, pivotProvider, child) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (Pivot pivot in pivotProvider.pivots)
                                Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          pivot.category.name,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          pivot.weight.toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: IconButton(
                                            iconSize: 26,
                                            icon: Icon(Icons.delete_forever),
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              _deletePivot(roomId, pivot.id);
                                            }),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 100.0),
                    Center(
                      child: RaisedButton(
                          elevation: 10,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50.0)),
                          child: Text('Next'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: pivots.isEmpty
                                      ? Colors.white
                                      : Colors.indigo)),
                          onPressed: pivots.isEmpty
                              ? null
                              : () => Navigator.pushNamed(
                                  context, CreateRoomBeers.routeName,
                                  arguments: roomId)),
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
