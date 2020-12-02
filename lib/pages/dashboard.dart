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
    // Provider.of<Courses>(context).fetchAndSetProducts(); // WON'T WORK!
    Future.delayed(Duration.zero).then((_) {
      Provider.of<RoomProvider>(context, listen: false).getAll();
    });
    super.initState();
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

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          messages[index],
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textController,
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        //Check if the textfield has text or not
        if (textController.text.isNotEmpty) {
          var data = {
            "data": {"id": 11, "passcode": "1234", "token": user.token}
          };
          //Send the message as JSON data to send_message event

          socket.connect();
          socket.emit('joinRoom', data);
          //Add the message to the list
          this.setState(() => messages.add(textController.text));
          textController.text = '';
          //Scrolldown the list to show the latest message
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.ease,
          );
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
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
