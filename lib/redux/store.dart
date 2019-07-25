import 'package:redux/redux.dart';

import 'package:retroshare/redux/reducers/identity_reducer.dart';
import 'package:retroshare/redux/model/identity_state.dart';

Future<Store<IdentityState>> createIdentityStore() async {
  return Store(
    identityStateReducers,
    initialState: IdentityState()
  );
}

