import 'package:flutter/material.dart';

import 'package:retroshare/main.dart';
import 'package:retroshare/ui/home_screen.dart';
import 'package:retroshare/ui/signin_screen.dart';
import 'package:retroshare/ui/signup_screen.dart';
import 'package:retroshare/ui/room/room_screen.dart';
import 'package:retroshare/ui/create_room.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/room':
        return MaterialPageRoute(builder: (_) => RoomScreen());
      case '/create_room':
        return MaterialPageRoute(builder: (_) => CreateRoomScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Error'),
          ),
        );
      }
    );
  }
}