import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';

import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/common/styles.dart';

import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  var _tapPosition;

  void _removeFromContacts(String gxsId) async {
    await setContact(gxsId, false);

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
              Icons.delete,
              color: Colors.black,
            ),
            title: Text("Remove from contacts",
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
      if (delta == 0) _removeFromContacts(gxsId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: StoreConnector<AppState, List<Identity>>(
        converter: (store) => store.state.friendsIdsList,
        builder: (context, friendsIdsList) {
          return Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 8, right: 16, bottom: 8),
                    sliver: SliverFixedExtentList(
                      itemExtent: personDelegateHeight,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTapDown: _storePosition,
                            onLongPress: () {
                              _showCustomMenu(friendsIdsList[index].mId);
                            },
                            child: PersonDelegate(
                              data: PersonDelegateData(
                                name: friendsIdsList[index].name,
                                mId: friendsIdsList[index].mId,
                                profileImage: friendsIdsList[index].avatar,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/room',
                                  arguments: {
                                    'isRoom': false,
                                    'chatData': Chat(
                                      interlocutorId: friendsIdsList[index],
                                      isPublic: false,
                                      numberOfParticipants: 1,
                                    ),
                                  },
                                );
                              },
                            ),
                          );
                        },
                        childCount: friendsIdsList.length,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: friendsIdsList.isEmpty,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/icons8/list-is-empty-3.png'),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Looks like an empty space',
                            style: Theme.of(context).textTheme.body2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'You can add friends in the menu',
                            style: Theme.of(context).textTheme.body1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
