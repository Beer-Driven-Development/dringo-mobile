import 'dart:collection';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/user_provider.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void getUser() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
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
              child: Text(beers.first.name),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(pivots.first.category.name),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(pivots.first.weight.toString()),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
