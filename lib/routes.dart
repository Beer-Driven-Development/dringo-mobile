import 'package:dringo/pages/create_room/create_room_categories.dart';
import 'package:dringo/pages/create_room/create_room_name_passcode.dart';
import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/pages/register.dart';
import 'package:dringo/pages/room.dart';

final routes = {
  DashBoard.routeName: (ctx) => DashBoard(),
  Login.routeName: (ctx) => Login(),
  Register.routeName: (ctx) => Register(),
  Room.routeName: (ctx) => Room(),
  CreateRoomNamePasscode.routeName: (ctx) =>CreateRoomNamePasscode(),
  CreateRoomCategories.routeName: (ctx) =>CreateRoomCategories(),
};
