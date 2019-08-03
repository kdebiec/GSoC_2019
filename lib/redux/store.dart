import 'package:redux/redux.dart';

import 'package:retroshare/redux/reducers/app_reducer.dart';
import 'package:retroshare/redux/model/app_state.dart';

Future<Store<AppState>> createIdentityStore() async {
  return Store(
    identityStateReducers,
    initialState: AppState()
  );
}

