import 'package:flutter/material.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/services/auth.dart';
import 'package:retroshare/services/account.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/model/account.dart';

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
    if (!widget.isLoading)
      checkBackendState(context);
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
  if (isLoggedIn && isTokenValid) {
    await getOwnIdentities();
    Navigator.pushReplacementNamed(context, '/home');
  }
  else {
    await getLocations();
    if (accountsList.isEmpty)
      Navigator.pushReplacementNamed(context, '/launch_transition');
    else
      Navigator.pushReplacementNamed(context, '/signin');
  }
}
