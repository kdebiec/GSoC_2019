import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/routes.dart';
import 'package:retroshare/redux/store.dart';
import 'package:retroshare/redux/model/app_state.dart';

void main() async {
  final identityStore = await createIdentityStore();
  runApp(App(identityStore));
}

class App extends StatefulWidget {
  final Store<AppState> identityStore;

  App(this.identityStore);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.identityStore,
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Retroshare',
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
