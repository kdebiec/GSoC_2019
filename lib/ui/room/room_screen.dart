import 'package:flutter/material.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/room/messages_tab.dart';
import 'package:retroshare/ui/room/room_friends_tab.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final bool isOnline = true;
  final String profileImage = 'assets/profile.jpg';
  final String name = 'Sandie Gloop';

  Animation<Color> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

    _iconAnimation =
        ColorTween(begin: Colors.black45, end: Colors.lightBlueAccent)
            .animate(_tabController.animation);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: appBarHeight + 32,
            padding: const EdgeInsets.fromLTRB(8.0, 32.0, 16.0, 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: personDelegateHeight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: appBarHeight,
                  height: appBarHeight,
                  child: Stack(
                    alignment: Alignment(-1.0, 0.0),
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: appBarHeight * 0.8,
                          width: appBarHeight * 0.8,
                          decoration: BoxDecoration(
                            border: null,
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(
                                appBarHeight * 0.8 * 0.33),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(profileImage),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isOnline,
                        child: Positioned(
                          bottom: appBarHeight * 0.73,
                          left: appBarHeight * 0.73,
                          child: Container(
                            height: appBarHeight * 0.25,
                            width: appBarHeight * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  width: appBarHeight * 0.03),
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(
                                  appBarHeight * 0.3 * 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
                AnimatedBuilder(
                  animation: _tabController.animation,
                  builder: (BuildContext context, Widget widget){
                    return IconButton(
                      icon: Icon(
                        Icons.child_friendly,
                        size: 25,
                      ),
                      color: _iconAnimation.value,
                      onPressed: () {
                        _tabController.animateTo(1-_tabController.index);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MessagesTab(),
                RoomFriendsTab(),
              ],
            ),
          )
        ],
      ),
    );
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: appBarHeight + 32,
                  padding: const EdgeInsets.fromLTRB(8.0, 32.0, 16.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: personDelegateHeight,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 25,
                          ),
                          color: Color(0xFF9E9E9E),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        width: appBarHeight,
                        height: appBarHeight,
                        child: Stack(
                          alignment: Alignment(-1.0, 0.0),
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: appBarHeight * 0.8,
                                width: appBarHeight * 0.8,
                                decoration: BoxDecoration(
                                  border: null,
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(
                                      appBarHeight * 0.8 * 0.33),
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage(profileImage),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isOnline,
                              child: Positioned(
                                bottom: appBarHeight * 0.73,
                                left: appBarHeight * 0.73,
                                child: Container(
                                  height: appBarHeight * 0.25,
                                  width: appBarHeight * 0.25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: appBarHeight * 0.03),
                                    color: Colors.lightGreenAccent,
                                    borderRadius: BorderRadius.circular(
                                        appBarHeight * 0.3 * 0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: messageData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MessageDelegate(
                          data: messageData[index],
                        );
                      }),
                ),
              ],
            ),
          ),
          // BottomBar
          Container(
            height: appBarHeight,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  spreadRadius: 5.0,
                  offset: Offset(
                    0.0,
                    15.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(appBarHeight / 3),
                  topRight: Radius.circular(appBarHeight / 3)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                    ),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.image,
                    ),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF5F5F5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type text...'),
                                style: Theme.of(context).textTheme.body2,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.face,
                              ),
                              color: Color(0xFF9E9E9E),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
