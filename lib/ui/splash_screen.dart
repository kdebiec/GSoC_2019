import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:retroshare/model/location.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkBackendState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/rs-logo.png',
          ),
        ),
      ),
    );
  }
}

void checkBackendState(BuildContext context) async {
  bool loggedIn = await checkLoggedIn();
  if (loggedIn)
    Navigator.pushReplacementNamed(context, '/home');
  else {
    accountsList = await getLocations();
    Navigator.pushReplacementNamed(context, '/signin');
  }
}

dynamic checkLoggedIn() async {
  final response =
      await http.get('http://localhost:9092/rsLoginHelper/isLoggedIn');

  if (response.statusCode == 200)
    return json.decode(response.body)['retval'];
  else
    throw Exception('Failed to load response');
}

Future<List<Account>> getLocations() async {
  final response =
      await http.get('http://localhost:9092/rsLoginHelper/getLocations');

  if (response.statusCode == 200) {
    print(response.body);

    List<Account> accountsList = new List();
    json.decode(response.body)['locations'].forEach((location) {
      if (location != null)
        accountsList.add(Account(location['mLocationId'], location['mPgpId'],
            location['mLocationName'], location['mPpgName']));
    });

    return accountsList;
  } else
    throw Exception('Failed to load response');
}
