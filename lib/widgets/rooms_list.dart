import 'package:dringo/domain/room.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomsList extends StatelessWidget {
  RoomsList();

  @override
  Widget build(BuildContext context) {
    final roomsData = Provider.of<RoomProvider>(context);
    final rooms = roomsData.rooms;

    ListTile makeListTile(Room room) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            room.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {},
        );

    Card makeCard(Room room) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(room),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: rooms.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: rooms[i],
          child: makeCard(rooms[i]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );
  }
}
