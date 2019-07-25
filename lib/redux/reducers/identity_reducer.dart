import 'package:retroshare/model/identity.dart';
import 'package:retroshare/redux/model/identity_state.dart';
import 'package:retroshare/redux/actions/identity_actions.dart';

IdentityState identityStateReducers(IdentityState state, dynamic action) {
  if (action is ChangeIdentityAction)
    return changeIdentity(state.ownIdsList, action);
  else if (action is UpdateIdentitiesAction)
    return updateOwnIdentities(state.currId, action);

  return state;
}

IdentityState changeIdentity(
    List<Identity> idsList, ChangeIdentityAction action) {
  return IdentityState(idsList, action.identity);
}

IdentityState updateOwnIdentities(
    Identity ownId, UpdateIdentitiesAction action) {
  return IdentityState(
      action.ownIdsList,
      ownId == null
          ? (action.ownIdsList == null ? null : action.ownIdsList.first)
          : ownId);
}
