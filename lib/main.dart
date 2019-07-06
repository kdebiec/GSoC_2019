import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:retroshare/routes.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return OKToast (
      child: MaterialApp (
        debugShowCheckedModeBanner: false,
        title: 'Retroshare',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/signin');
        },
        child: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/rs-logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
