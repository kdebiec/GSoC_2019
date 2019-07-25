import 'package:retroshare/model/identity.dart';

class IdentityState {
  final List<Identity> ownIdsList;
  final Identity currId;

  IdentityState([this.ownIdsList, this.currId]);
}