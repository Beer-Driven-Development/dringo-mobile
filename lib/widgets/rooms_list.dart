import 'package:dringo/domain/message_model.dart';
import 'package:dringo/domain/room.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/pages/room.dart' as RoomPage;
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/services/socket_service.dart';
import 'package:dringo/widgets/room_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class RoomsList extends StatefulWidget {
  RoomsList();

  @override
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> with SecureStorageMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final roomsData = Provider.of<RoomProvider>(context);
    final rooms = roomsData.rooms;



    RoomItem makeCard(Room room) => RoomItem(room: room);

    final makeBody = Container(
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<RoomProvider>(context, listen: false).getAll();
          return Provider.of<RoomProvider>(context, listen: false).rooms;
        },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: rooms.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(

            value: rooms[i],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RoomItem(room: rooms[i]),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );
  }
}
