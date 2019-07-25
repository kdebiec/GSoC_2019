import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:redux/redux.dart';

import 'package:retroshare/routes.dart';
import 'package:retroshare/redux/store.dart';
import 'package:retroshare/redux/model/identity_state.dart';

void main() async {
  final identityStore = await createIdentityStore();
  runApp(App(identityStore));
}

class App extends StatefulWidget {
  final Store<IdentityState> identityStore;

  App(this.identityStore);

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Retroshare',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(color: Colors.black12),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}