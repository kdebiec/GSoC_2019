import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';

import 'dart:math' as math;

import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/services/chat.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/person_delegate.dart';

import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class SearchScreen extends StatefulWidget {
  final int initialTab;

  SearchScreen({Key key, this.initialTab}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _searchBoxFilter = TextEditingController();
  Animation<Color> _leftTabIconColor;
  Animation<Color> _rightTabIconColor;

  String _searchContent = '';
  List<Identity> allIds = List();
  List<Identity> filteredAllIds = List();
  List<Identity> contactsIds = List();
  List<Identity> filteredContactsIds = List();
  List<Chat> subscribedChats = List();
  List<Chat> filteredSubscribedChats = List();
  List<Chat> publicChats = List();
  List<Chat> filteredPublicChats = List();

  var _tapPosition;

  @override
  void initState() {
    _getChats();

    _tabController =
        TabController(vsync: this, length: 2, initialIndex: widget.initialTab);

    _searchBoxFilter.addListener(() {
      if (_searchBoxFilter.text.isEmpty) {
        setState(() {
          _searchContent = "";
          filteredAllIds = allIds;
          filteredContactsIds = contactsIds;
          filteredSubscribedChats = subscribedChats;
          filteredPublicChats = publicChats;
        });
      } else {
        setState(() {
          _searchContent = _searchBoxFilter.text;
        });
      }
    });

    _leftTabIconColor = ColorTween(begin: Color(0xFFF5F5F5), end: Colors.white)
        .animate(_tabController.animation);
    _rightTabIconColor = ColorTween(begin: Colors.white, end: Color(0xFFF5F5F5))
        .animate(_tabController.animation);

    super.initState();
  }

  void _getChats() async {
    publicChats = await getUnsubscribedChatLobbies();
    setState(() {});
  }

  void _goToChat(int lobbyId) async {
    final store = StoreProvider.of<AppState>(context);
    bool success = await joinChatLobby(lobbyId, store.state.currId.mId);

    if (success) {
      Chat chat = await getChatLobbyInfo(lobbyId);
      Navigator.pushNamed(context, '/room',
          arguments: {'isRoom': true, 'chatData': chat});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 3 * personDelegateHeight / 4,
        maxHeight: 3 * personDelegateHeight / 4,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: personDelegateHeight / 4),
          alignment: Alignment.centerLeft,
          child: Text(
            headerText,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    allIds = store.state.allIdsList;
    contactsIds = store.state.friendsIdsList;
    subscribedChats = store.state.subscribedChats;

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
                    child: Hero(
                      tag: 'search_box',
                      child: Material(
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFF5F5F5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.search,
                                    color: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .color),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchBoxFilter,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Type text...'),
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: (appBarHeight - 40) / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _tabController.animation,
                      builder: (BuildContext context, Widget widget) {
                        return GestureDetector(
                          onTap: () {
                            _tabController.animateTo(0);
                          },
                          child: Container(
                            width: 2 * appBarHeight,
                            decoration: BoxDecoration(
                              color: _leftTabIconColor.value,
                              borderRadius:
                                  BorderRadius.circular(appBarHeight / 2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  'Chats',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AnimatedBuilder(
                      animation: _tabController.animation,
                      builder: (BuildContext context, Widget widget) {
                        return GestureDetector(
                          onTap: () {
                            _tabController.animateTo(1);
                          },
                          child: Container(
                            width: 2 * appBarHeight,
                            decoration: BoxDecoration(
                              color: _rightTabIconColor.value,
                              borderRadius:
                                  BorderRadius.circular(appBarHeight / 2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  'People',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Stack(
                    children: <Widget>[
                      _buildChatsList(),
                      Visibility(
                        visible: filteredSubscribedChats.isEmpty &&
                            filteredPublicChats.isEmpty,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Container(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icons8/sport-yoga-reading-1.png'),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 25),
                                    child: Text(
                                      'Nothing was found',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      _buildPeopleList(),
                      Visibility(
                        visible: filteredAllIds.isEmpty &&
                            filteredContactsIds.isEmpty,
                        child: Center(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icons8/virtual-reality.png'),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 25),
                                    child: Text(
                                      'Nothing was found',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    if (_searchContent.isNotEmpty) {
      List<Chat> tempChatsList = new List();
      for (int i = 0; i < subscribedChats.length; i++) {
        if (subscribedChats[i]
            .chatName
            .toLowerCase()
            .contains(_searchContent.toLowerCase())) {
          tempChatsList.add(subscribedChats[i]);
        }
      }
      filteredSubscribedChats = tempChatsList;

      List<Chat> tempList = new List();
      for (int i = 0; i < publicChats.length; i++) {
        if (publicChats[i]
            .chatName
            .toLowerCase()
            .contains(_searchContent.toLowerCase())) {
          tempList.add(publicChats[i]);
        }
      }
      filteredPublicChats = tempList;
    } else {
      filteredSubscribedChats = subscribedChats;
      filteredPublicChats = publicChats;
    }

    return Visibility(
      visible:
          filteredSubscribedChats.isNotEmpty || filteredPublicChats.isNotEmpty,
      child: CustomScrollView(
        slivers: <Widget>[
          makeHeader('Subscribed chats'),
          SliverFixedExtentList(
            itemExtent: personDelegateHeight,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return PersonDelegate(
                  data: PersonDelegateData(
                    name: filteredSubscribedChats[index].chatName,
                    mId: filteredSubscribedChats[index].chatId.toString(),
                    isRoom: true,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/room', arguments: {
                      'isRoom': true,
                      'chatData': filteredSubscribedChats[index]
                    });
                  },
                );
              },
              childCount: filteredSubscribedChats.length,
            ),
          ),
          makeHeader('Public chats'),
          SliverFixedExtentList(
            itemExtent: personDelegateHeight,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _goToChat(filteredPublicChats[index].chatId);
                  },
                  child: PersonDelegate(
                    data: PersonDelegateData(
                      name: filteredPublicChats[index].chatName,
                      mId: filteredPublicChats[index].chatId.toString(),
                      isRoom: true,
                    ),
                    onPressed: () {
                      _goToChat(filteredPublicChats[index].chatId);
                    },
                  ),
                );
              },
              childCount: filteredPublicChats.length,
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromContacts(String gxsId) async {
    await setContact(gxsId, false);

    final store = StoreProvider.of<AppState>(context);
    Tuple3<List<Identity>, List<Identity>, List<Identity>> tupleIds =
        await getAllIdentities();
    store.dispatch(UpdateFriendsSignedIdentitiesAction(tupleIds.item1));
    store.dispatch(UpdateFriendsIdentitiesAction(tupleIds.item2));
    store.dispatch(UpdateAllIdentitiesAction(tupleIds.item3));
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

  void _showCustomMenu(String gxsId, bool shouldAdd) async {
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
              shouldAdd ? Icons.person_add : Icons.delete,
              color: Colors.black,
            ),
            title: Text(shouldAdd ? "Add to contacts" : "Remove from contacts",
                style: Theme.of(context).textTheme.body2),
          ),
        ),
      ],
      position: RelativeRect.fromRect(
        _tapPosition & Size(40, 40),
        Offset.zero & overlay.semanticBounds.size,
      ),
    );

    if (delta != null && delta == 0) {
      if (shouldAdd)
        _addToContacts(gxsId);
      else
        _removeFromContacts(gxsId);
    }
  }

  Widget _buildPeopleList() {
    if (_searchContent.isNotEmpty) {
      List<Identity> tempContactsList = new List();
      for (int i = 0; i < contactsIds.length; i++) {
        if (contactsIds[i]
            .name
            .toLowerCase()
            .contains(_searchContent.toLowerCase())) {
          tempContactsList.add(contactsIds[i]);
        }
      }
      filteredContactsIds = tempContactsList;

      List<Identity> tempList = new List();
      for (int i = 0; i < allIds.length; i++) {
        if (allIds[i]
            .name
            .toLowerCase()
            .contains(_searchContent.toLowerCase())) {
          tempList.add(allIds[i]);
        }
      }
      filteredAllIds = tempList;
    } else {
      filteredContactsIds = contactsIds;
      filteredAllIds = allIds;
    }

    return Visibility(
      visible: filteredAllIds.isNotEmpty || filteredContactsIds.isNotEmpty,
      child: CustomScrollView(
        slivers: <Widget>[
          makeHeader('Contacts'),
          SliverFixedExtentList(
            itemExtent: personDelegateHeight,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTapDown: _storePosition,
                  onLongPress: () {
                    _showCustomMenu(filteredAllIds[index].mId, false);
                  },
                  child: PersonDelegate(
                    data: PersonDelegateData(
                      name: filteredContactsIds[index].name,
                      mId: filteredContactsIds[index].mId,
                      profileImage: filteredContactsIds[index].avatar,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/room',
                        arguments: {
                          'isRoom': false,
                          'chatData': Chat(
                            interlocutorId: filteredContactsIds[index],
                            isPublic: false,
                            numberOfParticipants: 1,
                          ),
                        },
                      );
                    },
                  ),
                );
              },
              childCount: filteredContactsIds.length,
            ),
          ),
          makeHeader('People'),
          SliverFixedExtentList(
            itemExtent: personDelegateHeight,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTapDown: _storePosition,
                  onLongPress: () {
                    _showCustomMenu(filteredAllIds[index].mId, true);
                  },
                  child: PersonDelegate(
                    data: PersonDelegateData(
                      name: filteredAllIds[index].name,
                      mId: filteredAllIds[index].mId,
                      profileImage: filteredAllIds[index].avatar,
                    ),
                  ),
                );
              },
              childCount: filteredAllIds.length,
            ),
          ),
        ],
      ),
    );
  }
}
