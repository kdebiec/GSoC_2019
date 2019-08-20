import 'package:retroshare/model/identity.dart';
import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

AppState identityStateReducers(AppState state, dynamic action) {
  if (action is ChangeCurrentIdentityAction)
    return changeCurrentIdentity(state, action);
  else if (action is UpdateOwnIdentitiesAction)
    return updateOwnIdentities(state, action);
  else if (action is ChangeSelectedIdentityAction)
    return changeSelectedIdentity(state, action);
  else if (action is UpdateFriendsIdentitiesAction)
    return updateFriendsIdentities(state, action);
  else if (action is UpdateFriendsSignedIdentitiesAction)
    return updateFriendsSignedIdentities(state, action);
  else if (action is UpdateAllIdentitiesAction)
    return updateAllIdentitiesAction(state, action);
  else if (action is UpdateSubscribedChatsAction)
    return updateSubscribedChats(state, action);

  return state;
}

AppState changeCurrentIdentity(
    AppState state, ChangeCurrentIdentityAction action) {
  return AppState(
      state.ownIdsList,
      action.identity,
      state.selectedId,
      state.friendsIdsList,
      state.friendsSignedIdsList,
      state.allIdsList,
      state.subscribedChats);
}

AppState updateOwnIdentities(AppState state, UpdateOwnIdentitiesAction action) {
  Identity currId = state.currId == null
      ? (action.ownIdsList == null ? null : action.ownIdsList.first)
      : state.currId;
  return AppState(action.ownIdsList, currId, currId, state.friendsIdsList,
      state.friendsSignedIdsList, state.allIdsList, state.subscribedChats);
}

AppState changeSelectedIdentity(
    AppState state, ChangeSelectedIdentityAction action) {
  return AppState(
      state.ownIdsList,
      state.currId,
      action.identity,
      state.friendsIdsList,
      state.friendsSignedIdsList,
      state.allIdsList,
      state.subscribedChats);
}

AppState updateFriendsIdentities(
    AppState state, UpdateFriendsIdentitiesAction action) {
  return AppState(
      state.ownIdsList,
      state.currId,
      state.selectedId,
      action.friendsIdsList,
      state.friendsSignedIdsList,
      state.allIdsList,
      state.subscribedChats);
}

AppState updateFriendsSignedIdentities(
    AppState state, UpdateFriendsSignedIdentitiesAction action) {
  return AppState(
      state.ownIdsList,
      state.currId,
      state.selectedId,
      state.friendsIdsList,
      action.friendsSignedIdsList,
      state.allIdsList,
      state.subscribedChats);
}

AppState updateAllIdentitiesAction(
    AppState state, UpdateAllIdentitiesAction action) {
  return AppState(
      state.ownIdsList,
      state.currId,
      state.selectedId,
      state.friendsIdsList,
      state.friendsSignedIdsList,
      action.allIdsList,
      state.subscribedChats);
}

AppState updateSubscribedChats(
    AppState state, UpdateSubscribedChatsAction action) {
  return AppState(
      state.ownIdsList,
      state.currId,
      state.selectedId,
      state.friendsIdsList,
      state.friendsSignedIdsList,
      state.allIdsList,
      action.subscribedChats);
}
