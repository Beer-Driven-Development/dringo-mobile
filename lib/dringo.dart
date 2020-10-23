import 'package:dringo/providers/auth.dart';
import 'package:dringo/routes.dart';
import 'package:dringo/screens/HomeScreen.dart';
import 'package:dringo/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dringo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                title: 'audioholics',
                theme: ThemeData(
                  primarySwatch: Colors.deepPurple,
                  accentColor: Colors.blue,
                  fontFamily: 'Montserrat',
                ).copyWith(
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: <TargetPlatform, PageTransitionsBuilder>{
                      TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    },
                  ),
                ),
                home: auth.isAuth
                    ? HomeScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) => LoginScreen(),
                      ),
                routes: routes)));
  }
}
