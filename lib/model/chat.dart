class Chat {
  int chatId;
  String chatName;
  String ownIdToUse;
  String lobbyTopic;
  bool isPublic;
  int numberOfParticipants;

  Chat(
      {this.chatId,
      this.chatName,
      this.lobbyTopic,
      this.ownIdToUse,
      this.isPublic,
      this.numberOfParticipants});
}
