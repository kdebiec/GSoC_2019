import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import 'package:retroshare/model/auth.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/identity.dart';

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
    json.decode(response.body)['public_lobbies'].forEach((chat) {
      if (chat != null && chat['lobby_flags'] != 0 && chat['lobby_flags'] != 4)
        chatsList.add(Chat(
          chatId: chat['lobby_id'].toInt(),
          chatName: chat['lobby_name'],
          lobbyTopic: chat['lobby_topic'],
          numberOfParticipants: chat['total_number_of_peers'],
        ));
    });
    return chatsList;
  } else {
    throw Exception('Failed to load response');
  }
}

Future<List<Chat>> getSubscribedChatLobbies() async {
  final response = await http.get(
    'http://localhost:9092/rsMsgs/getChatLobbyList',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
  );

  List<Chat> chatsList = List<Chat>();

  if (response.statusCode == 200) {
    var list = json.decode(response.body)['cl_list'];
    for (int i = 0; i < list.length; i++) {
      Chat chatItem;
      chatItem = await getChatLobbyInfo(list[i].toInt());

      chatsList.add(chatItem);
    }

    return chatsList;
  } else
    throw Exception('Failed to load response');
}

Future<Chat> getChatLobbyInfo(int lobbyId) async {
  final response =
      await http.post('http://localhost:9092/rsMsgs/getChatLobbyInfo',
          headers: {
            HttpHeaders.authorizationHeader:
                'Basic ' + base64.encode(utf8.encode('$authToken'))
          },
          body: json.encode({'id': lobbyId}));

  if (response.statusCode == 200) {
    if (json.decode(response.body)['retval']) {
      var chat = json.decode(response.body)['info'];
      return Chat(
          chatId: chat['lobby_id'].toInt(),
          chatName: chat['lobby_name'],
          lobbyTopic: chat['lobby_topic'],
          ownIdToUse: chat['gxs_id']);
    } else
      return Chat(
          chatId: 0,
          chatName: "Error",
          lobbyTopic: "Couldn't load room details");
  } else
    throw Exception('Failed to load response');
}

Future<bool> joinChatLobby(int chatId, String idToUse) async {
  final response = await http.post(
    'http://localhost:9092/rsMsgs/joinVisibleChatLobby',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
    body: json.encode({'lobby_id': chatId, 'own_id': idToUse}),
  );

  if (response.statusCode == 200)
    return json.decode(response.body)['retval'];
  else
    throw Exception('Failed to load response');
}

Future<bool> createChatLobby(
    String lobbyName, String idToUse, String lobbyTopic) async {
  final response = await http.post(
    'http://localhost:9092/rsMsgs/createChatLobby',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
    body: json.encode({
      'lobby_name': lobbyName,
      'lobby_identity': idToUse,
      'lobby_topic': lobbyTopic
    }),
  );

  if (response.statusCode == 200)
    return json.decode(response.body)['retval'];
  else
    throw Exception('Failed to load response');
}

Future<bool> sendMessage(int chatId, String msg) async {
      'id': chatId,
      'msg': msg,
    }),
  );

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body)['retval'];
  } else
    throw Exception('Failed to load response');
}

Future<List<Identity>> getLobbyParticipants(int lobbyId) async {
  final response = await http.post(
    'http://localhost:9092/rsMsgs/getChatLobbyInfo',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
    body: json.encode({
      'id': lobbyId,
    }),
  );

  List<Identity> ids = List<Identity>();

  if (response.statusCode == 200) {
    var gxsIds = json.decode(response.body)['info']['gxs_ids'];
    for (int i = 0; i < gxsIds.length; i++) {
      bool success = true;
      Identity id;
      do {
        Tuple2<bool, Identity> tuple = await getIdDetails(gxsIds[i]['key']);
        success = tuple.item1;
        id = tuple.item2;
      } while (!success);

      ids.add(id);
    }
    return ids;
  } else
    throw Exception('Failed to load response');
}
