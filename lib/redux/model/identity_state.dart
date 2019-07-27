import 'package:retroshare/model/identity.dart';

class IdentityState {
  final List<Identity> ownIdsList;
  final Identity currId;
  final Identity selectedId;

  IdentityState([this.ownIdsList, this.currId, this.selectedId]);
}