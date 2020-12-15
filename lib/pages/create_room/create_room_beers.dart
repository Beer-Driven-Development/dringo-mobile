import 'package:dringo/domain/beer.dart';
import 'package:dringo/providers/beer_provider.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomBeers extends StatefulWidget {
  static const routeName = '/create-room-3';

  @override
  _CreateRoomBeersState createState() => _CreateRoomBeersState();
}

class _CreateRoomBeersState extends State<CreateRoomBeers> {
  final formKey = new GlobalKey<FormState>();
  List<Beer> beers = [];
  String _beerName;
  double _beerAbv;
  int roomId;
  var _isInit = true;
  var _isButtonDisabled;

  _addBeer(Beer beer) async {
    await Provider.of<BeerProvider>(context, listen: false).addBeer(beer);
    setState(()  {
      beers =  Provider.of<BeerProvider>(context, listen: false).beers;
      _isButtonDisabled = false;
    });
  }

  _deleteBeer(Beer beer) {
    Provider.of<BeerProvider>(context, listen: false).deleteBeer(beer);
    beers.remove(beer);
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
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 75.0),
                  Text(
                    'Add beer',
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Playfair Display'),
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      cursorColor: Colors.indigo,
                      style: TextStyle(fontSize: 18.0, color: Colors.indigo),
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
                      cursorColor: Colors.indigo,
                      style: TextStyle(fontSize: 18.0, color: Colors.indigo),
                      autofocus: false,
                      validator: (value) => (double.parse(value) >= 0 &&
                              double.parse(value) < 100)
                          ? "Please enter valid abv of beer"
                          : null,
                      onChanged: (value) => _beerAbv = double.parse(value),
                      decoration: buildInputDecoration(
                          "Alcohol by value", Icons.sports_bar_sharp),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                          _addBeer(beer);
                        },
                      ),
                    ),
                  ),
                  Consumer<BeerProvider>(
                    builder: (context, beerProvider, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: beers.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          beers[index].name,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          beers[index].abv.toString() + '%',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: IconButton(
                                            iconSize: 26.0,
                                            icon: Icon(Icons.delete_forever),
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              _deleteBeer(beers[index]);
                                            }),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: RaisedButton(
                              elevation: 10,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50.0)),
                              child: Text('Draft'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: _isButtonDisabled
                                          ? Colors.white
                                          : Colors.indigoAccent)),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () => {
                                        Navigator.popUntil(context, (route) {
                                          return route.isFirst;
                                        })
                                      },
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: RaisedButton(
                              elevation: 10,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50.0)),
                              child: Text('Publish'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: _isButtonDisabled
                                          ? Colors.white
                                          : Colors.indigoAccent)),
                              onPressed: _isButtonDisabled
                                  ? null
                                  : () async => {
                                        await Provider.of<RoomProvider>(context,
                                                listen: false)
                                            .changeStatus(roomId),
                                        Navigator.pop(context),
                                        Navigator.pop(context),
                                        Navigator.pop(context),
                                      },
                            ),
                          ),
                        ),
                      ]),
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
