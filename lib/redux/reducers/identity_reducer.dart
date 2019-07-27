import 'package:retroshare/model/identity.dart';
import 'package:retroshare/redux/model/identity_state.dart';
import 'package:retroshare/redux/actions/identity_actions.dart';

IdentityState identityStateReducers(IdentityState state, dynamic action) {
  if (action is ChangeCurrentIdentityAction)
    return changeCurrentIdentity(state.ownIdsList, state.selectedId, action);
  else if (action is UpdateIdentitiesAction)
    return updateOwnIdentities(state.currId, state.selectedId, action);
  else if (action is ChangeSelectedIdentityAction)
    return changeSelectedIdentity(state.ownIdsList, state.currId, action);

  return state;
}

IdentityState changeCurrentIdentity(
    List<Identity> idsList, Identity selectedId, ChangeCurrentIdentityAction action) {
  return IdentityState(idsList, action.identity, selectedId);
}

IdentityState updateOwnIdentities(
    Identity ownId, Identity selectedId, UpdateIdentitiesAction action) {
  return IdentityState(
      action.ownIdsList,
      ownId == null
          ? (action.ownIdsList == null ? null : action.ownIdsList.first)
          : ownId, ownId == null
      ? (action.ownIdsList == null ? null : action.ownIdsList.first)
      : ownId);
}

IdentityState changeSelectedIdentity(
    List<Identity> idsList, Identity currentId, ChangeSelectedIdentityAction action) {
  return IdentityState(idsList, currentId, action.identity);
}