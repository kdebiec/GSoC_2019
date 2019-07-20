class Identity {
  String mId;
  String name;

  Identity(this.mId, [this.name = '']);
}

List<Identity> ownSignedIdsList;
List<Identity> ownPseudonymousIdsList;
List<Identity> ownIdsList;

Identity currId;