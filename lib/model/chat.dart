import 'package:retroshare/model/identity.dart';

class Chat {
  int chatId;
  String chatName;
  String ownIdToUse;
  Identity interlocutorId;
  String lobbyTopic;
  bool isPublic;
  int numberOfParticipants;

  Chat(
      {this.chatId,
      this.chatName,
      this.lobbyTopic,
      this.ownIdToUse,
      this.interlocutorId,
      this.isPublic,
      this.numberOfParticipants});
}

class Message {
  String msgId;
  String msgContent;
  String authorName;
  String authorId;
  String receiveTime;
  bool isSent;

  Message(
      {this.msgId,
      this.msgContent,
      this.authorName,
      this.authorId,
      this.receiveTime,
      this.isSent});
}
