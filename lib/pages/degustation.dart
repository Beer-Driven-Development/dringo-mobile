import 'dart:collection';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/widgets/pivot_item.dart';
import 'package:flutter/material.dart';
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
    // final SocketService socketService = injector.get<SocketService>();
    void dispose() {
      super.dispose();
    }

    beers = Provider.of<DegustationProvider>(context, listen: true).beers;
    pivots = Provider.of<DegustationProvider>(context, listen: true).pivots;
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
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: pivots.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: pivots[i],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: PivotItem(
                    pivot: pivots[i],
                    beer: beers.first,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
