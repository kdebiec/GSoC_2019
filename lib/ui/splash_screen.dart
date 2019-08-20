import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/services/auth.dart';
import 'package:retroshare/services/account.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/services/chat.dart';
import 'package:retroshare/model/account.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/chat.dart';

import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

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

    if (ownIdsList.isEmpty)
      Navigator.pushReplacementNamed(context, '/create_identity',
          arguments: true);
    else {
      List<Chat> chatsList = await getSubscribedChatLobbies();
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(UpdateOwnIdentitiesAction(ownIdsList));
      store.dispatch(UpdateSubscribedChatsAction(chatsList));
      Tuple3<List<Identity>, List<Identity>, List<Identity>> tupleIds =
          await getAllIdentities();
      print('Hello');
      store.dispatch(UpdateFriendsSignedIdentitiesAction(tupleIds.item1));
      store.dispatch(UpdateFriendsIdentitiesAction(tupleIds.item2));
      store.dispatch(UpdateAllIdentitiesAction(tupleIds.item3));
      Navigator.pushReplacementNamed(context, '/home');
    }
  } else {
    await getLocations();
    if (accountsList.isEmpty)
      Navigator.pushReplacementNamed(context, '/launch_transition');
    else
      Navigator.pushReplacementNamed(context, '/signin');
  }
}
