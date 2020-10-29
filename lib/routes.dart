import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/pages/register.dart';
import 'package:dringo/util/app_url.dart';
import 'package:web_socket_channel/io.dart';

final routes = {
  DashBoard.routeName: (ctx) => DashBoard(
        channel: IOWebSocketChannel.connect(AppUrl.baseWsURL),
      ),
  Login.routeName: (ctx) => Login(),
  Register.routeName: (ctx) => Register(),
};
