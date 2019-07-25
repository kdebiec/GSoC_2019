import 'package:retroshare/model/identity.dart';

class ChangeIdentityAction {
  final Identity identity;

  ChangeIdentityAction(this.identity);
}

class UpdateIdentitiesAction {
  final List<Identity> ownIdsList;

  UpdateIdentitiesAction(this.ownIdsList);
}