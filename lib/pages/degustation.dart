import 'dart:collection';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/degustation_data.dart';
import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/main.dart';
import 'package:dringo/pages/statistics.dart';
import 'package:dringo/providers/degustation_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/stream_socket.dart';
import 'package:dringo/widgets/pivot_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Degustation extends StatefulWidget {
  static const routeName = '/degustation';
  @override
  _DegustationState createState() => _DegustationState();
}

class _DegustationState extends State<Degustation> with SecureStorageMixin {
  User user;
  Beer beer;
  List<Pivot> pivots = new List<Pivot>();
  double score;
  Rating currentRating = new Rating();
  Stream xD;
  Room room;
  bool status;
  String token;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      getUser();

      // Provider.of<DegustationProvider>(context, listen: false).first(room.id);
      xD = streamSocket.getResponse;
    });
    super.initState();
  }

  void getUser() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser();
    token = await getSecureStorage("token");
  }

  void getNext() async {
    await Provider.of<DegustationProvider>(context, listen: false)
        .next(room.id, beer.id);
  }

  void getFirst() async {
    await Provider.of<DegustationProvider>(context, listen: false)
        .first(room.id);
  }

  void getStats() async {
    await Provider.of<DegustationProvider>(context, listen: false)
        .getStats(room.id);
  }
  @override
  Widget build(BuildContext context) {
    // final SocketService socketService = injector.get<SocketService>();
    void dispose() {
      super.dispose();
    }

    var map = new LinkedHashMap<String, dynamic>();
    var participants = new List<User>();
    DegustationData args = ModalRoute.of(context).settings.arguments;
    room = args.room;
    beer = args.beer;
    pivots = args.pivots;
    Widget _getFAB() {
      user = Provider.of<UserProvider>(context, listen: false).user;
      if (room.creator.id == user.id) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.navigate_next_rounded),
              onPressed: () async {
                final token = await getSecureStorage("token");
                var message = new MessageModel()
                    .fromDataToJson(token.toString(), room.id, beer.id);
                emit('next', message);
              }),
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
        floatingActionButton: _getFAB(),
        body: Container(
          child: StreamBuilder(
            stream: streamSocket.getResponse,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 400) {
                  var message = new MessageModel().fromIdToJson(token, room.id);
                  emit('getStats', message);
                  getStats();
                  Navigator.pushReplacementNamed(
                      context, Statistics.routeName, arguments: room.id);
                } else if (snapshot.data != 400) {
                  map = snapshot.data;
                  beer = map['beer'];
                  pivots = map['pivots'];
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      beer.name,
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      beer.abv.toString() + '%',
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
                          child: PivotItem(pivot: pivots[i], beer: beer),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
