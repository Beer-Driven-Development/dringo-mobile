import 'package:dringo/domain/user.dart';
import 'package:dringo/pages/create_room/create_room_name_passcode.dart';
import 'package:dringo/providers/room_provider.dart';
import 'package:dringo/providers/user_provider.dart';
import 'package:dringo/widgets/app_drawer.dart';
import 'package:dringo/widgets/rooms_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/home';

  final String token;
  DashBoard({Key key, this.token}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var _isInit = true;
  var _isLoading = false;
  List<String> messages;
  double height, width;
  User user;
  var socket;

  TextEditingController textController;
  ScrollController scrollController;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      getUser();
      Provider.of<RoomProvider>(context, listen: false).getAll();
    });
    super.initState();
  }

  void getUser() async {
    user = await Provider.of<UserProvider>(context, listen: false).getUser();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<RoomProvider>(context).getAll().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white70,
      drawer: AppDrawer(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 60.0),
        child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, CreateRoomNamePasscode.routeName);
            }),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RoomsList(),
    );
  }
}
