import 'dart:collection';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Degustation extends StatefulWidget {
  static const routeName = '/degustation';

  @override
  _DegustationState createState() => _DegustationState();
}

class _DegustationState extends State<Degustation> with SecureStorageMixin {
  var user;
  List<Beer> beers = new List<Beer>();
  List<Pivot> pivots = new List<Pivot>();
  double score;
  Rating currentRating = new Rating();

  @override
  void initState() {
    super.initState();
  }

  void getUser() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    Room room = ModalRoute.of(context).settings.arguments as Room;
    beers = Provider.of<DegustationProvider>(context, listen: true).beers;
    pivots = Provider.of<DegustationProvider>(context, listen: true).pivots;

    // final SocketService socketService = injector.get<SocketService>();
    void dispose() {
      super.dispose();
    }

    var map = new LinkedHashMap<String, List<User>>();
    var participants = new List<User>();

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                beers.first.name,
                style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                beers.first.abv.toString() + '%',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Voting on ' +
                      pivots.first.category.name +
                      ' with weight ' +
                      pivots.first.weight.toString(),
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RatingBar.builder(
                glowColor: Colors.indigoAccent,
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.sports_bar_sharp,
                  color: Colors.indigo,
                ),
                onRatingUpdate: (score) {
                  this.score = score;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                elevation: 10,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)),
                child: Text(
                  'Vote'.toUpperCase(),
                  style: TextStyle(fontSize: 18.0, color: Colors.indigoAccent),
                ),
                onPressed: () async {
                  var rating = await Provider.of<DegustationProvider>(context,
                          listen: false)
                      .vote(room.id, beers.first.id, pivots.first.id, score);
                  currentRating = rating;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
