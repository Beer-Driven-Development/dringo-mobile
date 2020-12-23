import 'dart:collection';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/services/stream_socket.dart';
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

    var map = new LinkedHashMap<String, List<User>>();
    var participants = new List<User>();

    return StreamBuilder(
      stream: streamSocket.getResponse,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.runtimeType is Beer) {
            beers = snapshot.data;
          } else if (snapshot.data.runtimeType is Pivot) {
            pivots = snapshot.data;
          }
        }
        Future.delayed(Duration.zero).then((_) {
          getUser();
        });

        return WillPopScope(
          onWillPop: () async {
            final token = await getSecureStorage("token");
            // var message = new MessageModel().fromIdToJson(token.toString(), id);
            // emit('leaveRoom', message);
            return true;
          },
          child: Scaffold(
            body: Container(
                child: Column(
              children: [Text(beers.toString()), Text(pivots.toString())],
            )),
          ),
        );
      },
    );
  }
}
