class Chat {
  String chatId;
  String lobbyName;
  String ownIdToUse;
  String lobbyTopic;
  bool isPublic;
  int numberOfParticipants;

  Chat(
      {this.chatId,
      this.lobbyName,
      this.lobbyTopic,
      this.ownIdToUse,
      this.isPublic,
      this.numberOfParticipants});
}
