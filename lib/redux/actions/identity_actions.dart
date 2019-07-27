import 'package:retroshare/model/identity.dart';

class ChangeCurrentIdentityAction {
  final Identity identity;

  ChangeCurrentIdentityAction(this.identity);
}

class ChangeSelectedIdentityAction {
  final Identity identity;

  ChangeSelectedIdentityAction(this.identity);
}

class UpdateIdentitiesAction {
  final List<Identity> ownIdsList;

  UpdateIdentitiesAction(this.ownIdsList);
}