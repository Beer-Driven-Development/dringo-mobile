import 'package:dringo/domain/beer.dart';
import 'package:dringo/providers/beer_provider.dart';
import 'package:dringo/util/colors_palette.dart';
import 'package:dringo/util/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomBeers extends StatefulWidget {
  static const routeName = '/create-room-3';

  @override
  _CreateRoomBeersState createState() => _CreateRoomBeersState();
}

class _CreateRoomBeersState extends State<CreateRoomBeers> {
  final formKey = new GlobalKey<FormState>();
  var beers;
  String _beerName;
  double _beerAbv;
  int roomId;
  var _isInit = true;
  var _isButtonDisabled;

  _addBeer(Beer beer) {
    Provider.of<BeerProvider>(context, listen: false).addBeer(beer);
    setState(() {
      _isButtonDisabled = false;
    });
  }

  _deleteBeer(Beer beer) {
    Provider.of<BeerProvider>(context, listen: false).deleteBeer(beer);
    if (beers.isEmpty) {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  @override
  void initState() {
    _isButtonDisabled = true;
    beers = Provider.of<BeerProvider>(context, listen: false).beers;

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
                    'Add beer',
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
                    children: [],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      autofocus: false,
                      validator: (value) =>
                          value.isEmpty ? "Please enter name of beer" : null,
                      onChanged: (value) => _beerName = value,
                      decoration: buildInputDecoration(
                          "Name", Icons.assignment_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      autofocus: false,
                      validator: (value) =>
                          (value as double > 0 && value as double < 100)
                              ? "Please enter valid abv of beer"
                              : null,
                      onChanged: (value) => _beerAbv = double.parse(value),
                      decoration: buildInputDecoration(
                          "Alcohol by value", Icons.sports_bar_sharp),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        elevation: 10,
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0)),
                        child: Text('Add'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.indigoAccent)),
                        onPressed: () {
                          var beer = new Beer(
                              name: _beerName, abv: _beerAbv, roomId: roomId);

                          Provider.of<BeerProvider>(context, listen: false)
                              .addBeer(beer);
                        },
                      ),
                    ),
                  ),
                  Consumer<BeerProvider>(
                    builder: (context, beerProvider, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (Beer beer in beerProvider.beers)
                              Center(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        beer.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        beer.abv.toString() + '%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          color: Colors.white,
                                          onPressed: () {
                                            _deleteBeer(beer);
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
                  SizedBox(height: 200.0),
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
                              fontSize: 18.0,
                              color: _isButtonDisabled
                                  ? Colors.white70
                                  : Colors.indigoAccent)),
                      onPressed: beers.isEmpty ? null : () => createRoom,
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
