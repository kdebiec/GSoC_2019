import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/common/styles.dart';

import 'package:retroshare/services/chat.dart';
import 'package:retroshare/model/chat.dart';

import 'package:retroshare/redux/model/app_state.dart';

class DiscoverChatsScreen extends StatefulWidget {
  @override
  _DiscoverChatsScreenState createState() => _DiscoverChatsScreenState();
}

class _DiscoverChatsScreenState extends State<DiscoverChatsScreen> {
  List<Chat> _chatsList;

  @override
  void initState() {
    _getChats();
    super.initState();
  }

  void _getChats() async {
    getSubscribedChatLobbies();
    _chatsList = await getUnsubscribedChatLobbies();
    setState(() {});
  }

  void _goToChat(int lobbyId) async {
    final store = StoreProvider.of<AppState>(context);
    bool success = await joinChatLobby(lobbyId, store.state.currId.mId);

    if(success) {
      Chat chat = await getChatLobbyInfo(lobbyId);
      Navigator.pushNamed(context, '/room', arguments: {'isRoom': true, 'chatData': chat});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            Container(
              height: appBarHeight,
              child: Row(
                children: <Widget>[
                  Container(
                    width: personDelegateHeight,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Discover public chats',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _chatsList == null ? 0 : _chatsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _goToChat(_chatsList[index].chatId);
                    },
                    child: Container(
                      height: personDelegateHeight,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _chatsList[index].chatName,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                  Visibility(
                                    visible:
                                        _chatsList[index].lobbyTopic.isNotEmpty,
                                    child: Text(
                                      'Topic: ' + _chatsList[index].lobbyTopic,
                                      style: Theme.of(context).textTheme.body1,
                                    ),
                                  ),
                                  Text(
                                    'Number of participants: ' +
                                        _chatsList[index]
                                            .numberOfParticipants
                                            .toString(),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.input),
                              onPressed: () {
                                _goToChat(_chatsList[index].chatId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
