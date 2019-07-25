import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/services/auth.dart';
import 'package:retroshare/services/account.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/model/account.dart';
import 'package:retroshare/model/identity.dart';

import 'package:retroshare/redux/model/identity_state.dart';
import 'package:retroshare/redux/actions/identity_actions.dart';

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
    statusBarHeight = MediaQuery.of(context).padding.top;

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
    List<Identity> ownIdsList = await getOwnIdentities();
    final store = StoreProvider.of<IdentityState>(context);
    store.dispatch(UpdateIdentitiesAction(ownIdsList));

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
