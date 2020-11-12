import 'package:dringo/pages/dashboard.dart';
import 'package:dringo/pages/login.dart';
import 'package:dringo/pages/register.dart';
import 'package:dringo/util/app_url.dart';

final routes = {
  DashBoard.routeName: (ctx) => DashBoard(),
  Login.routeName: (ctx) => Login(),
  Register.routeName: (ctx) => Register(),
};
