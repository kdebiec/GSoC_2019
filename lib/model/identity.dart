class Identity {
  String mId;
  String name;
  String avatar;
  bool signed;
  bool isContact;

  Identity(this.mId, [this.signed, this.name = '', this.avatar = '', this.isContact = true]);
}