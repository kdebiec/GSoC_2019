import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/model/location.dart';
import 'package:retroshare/services/auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.isLoading = false}) : super(key: key);
  final isLoading;

  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.isLoading) checkBackendState(context);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Center(
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

void checkBackendState(BuildContext context) async {
  bool isLoggedIn = await checkLoggedIn();
  bool isTokenValid = await isAuthTokenValid();
  if (isLoggedIn && isTokenValid)
    Navigator.pushReplacementNamed(context, '/home');
  else {
    accountsList = await getLocations();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  // Jeśli nie ma żadnych kont daj uzytkownikowi wybor miedzy importowaniem konta
  // a stworzeniem nowego!!!
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

/*dynamic checkTokenAuth() async {
  if (authToken == null) {
    var token = {
      'token': '55bdef27fc9f7c46decdf637ab2e812f:password',
    };
    final response = await http.post(
        'http://localhost:9092/jsonApiServer/requestNewTokenAutorization',
        body: json.encode(token));

    //var uri = Uri.http('localhost:9092', 'jsonApiServer/requestNewTokenAutorization', token);

    //final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      print('tokenAuth' + response.body);
      return json.decode(response.body)['retval'];
      //return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  } else
    return true;
}*/
