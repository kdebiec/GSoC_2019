import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';

import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/chat.dart';
import 'package:retroshare/services/identity.dart';

import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class RoomFriendsTab extends StatefulWidget {
  final Chat chat;

  RoomFriendsTab({this.chat});

  @override
  _RoomFriendsTabState createState() => _RoomFriendsTabState();
}

class _RoomFriendsTabState extends State<RoomFriendsTab> {
  List<Identity> _lobbyParticipantsList = List<Identity>();
  var _tapPosition;

  @override
  void initState() {
    _getParticipants(widget.chat.chatId);
    super.initState();
  }

  void _getParticipants(int lobbyId) async {
    _lobbyParticipantsList = await getLobbyParticipants(lobbyId);
    setState(() {});
  }

  void _addToContacts(String gxsId) async {
    await setContact(gxsId, true);

    final store = StoreProvider.of<AppState>(context);
    Tuple3<List<Identity>, List<Identity>, List<Identity>> tupleIds =
        await getAllIdentities();
    store.dispatch(UpdateFriendsSignedIdentitiesAction(tupleIds.item1));
    store.dispatch(UpdateFriendsIdentitiesAction(tupleIds.item2));
    store.dispatch(UpdateAllIdentitiesAction(tupleIds.item3));
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showCustomMenu(String gxsId) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final delta = await showMenu(
      context: context,
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            enabled: true,
            leading: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
            title: Text("Add to contacts",
                style: Theme.of(context).textTheme.body2),
          ),
        ),
      ],
      position: RelativeRect.fromRect(
        _tapPosition & Size(40, 40),
        Offset.zero & overlay.semanticBounds.size,
      ),
    );

    if (delta != null) {
      if (delta == 0) _addToContacts(gxsId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:
          _lobbyParticipantsList == null ? 0 : _lobbyParticipantsList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTapDown: _storePosition,
          onLongPress: () {
            _showCustomMenu(_lobbyParticipantsList[index].mId);
          },
          child: PersonDelegate(
            data: PersonDelegateData(
              name: _lobbyParticipantsList[index].name,
              mId: _lobbyParticipantsList[index].mId,
              profileImage: _lobbyParticipantsList[index].avatar,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/room',
                arguments: {
                  'isRoom': false,
                  'chatData': Chat(
                    interlocutorId: _lobbyParticipantsList[index],
                    isPublic: false,
                    numberOfParticipants: 1,
                  ),
                },
              );
            },
          ),
        );
      },
    );
  }
}
