import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/chat.dart';

class AppState {
  final List<Identity> ownIdsList;
  final Identity currId;
  final Identity selectedId;
  final List<Identity> friendsIdsList;
  final List<Identity> friendsSignedIdsList;
  final List<Chat> subscribedChats;

  AppState([this.ownIdsList, this.currId, this.selectedId, this.friendsIdsList, this.friendsSignedIdsList, this.subscribedChats]);
}