import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/chat.dart';

class ChangeCurrentIdentityAction {
  final Identity identity;

  ChangeCurrentIdentityAction(this.identity);
}

class ChangeSelectedIdentityAction {
  final Identity identity;

  ChangeSelectedIdentityAction(this.identity);
}

class UpdateOwnIdentitiesAction {
  final List<Identity> ownIdsList;

  UpdateOwnIdentitiesAction(this.ownIdsList);
}

class UpdateFriendsIdentitiesAction {
  final List<Identity> friendsIdsList;

  UpdateFriendsIdentitiesAction(this.friendsIdsList);
}

class UpdateFriendsSignedIdentitiesAction {
  final List<Identity> friendsSignedIdsList;

  UpdateFriendsSignedIdentitiesAction(this.friendsSignedIdsList);
}

class UpdateSubscribedChatsAction {
  final List<Chat> subscribedChats;

  UpdateSubscribedChatsAction(this.subscribedChats);
}