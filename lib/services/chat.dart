import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:retroshare/model/auth.dart';
import 'package:retroshare/model/chat.dart';

Future<List<Chat>> getChatLobbies() async {
  final response = await http.get(
    'http://localhost:9092/rsMsgs/getListOfNearbyChatLobbies',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
  );

  List<Chat> chatsList = List<Chat>();

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    json.decode(response.body)['public_lobbies'].forEach((chat) {
      if (chat != null)
        chatsList.add(Chat(
            chatId: chat['lobby_id'].toString(),
            lobbyName: chat['lobby_name'],
            lobbyTopic: chat['lobby_topic'],
        numberOfParticipants: chat['total_number_of_peers']));
    });
    return chatsList;
    //return json.decode(response.body)['retval'];
  } else {
    throw Exception('Failed to load response');
  }
}
