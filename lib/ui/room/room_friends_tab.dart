import 'package:flutter/material.dart';

import 'package:retroshare/model/home_tabs.dart';
import 'package:retroshare/ui/person_delegate.dart';

class RoomFriendsTab extends StatefulWidget {
  @override
  _RoomFriendsTabState createState() => _RoomFriendsTabState();
}

class _RoomFriendsTabState extends State<RoomFriendsTab>
{
  @override
  Widget build(BuildContext context) {
    print(allPages.values.length);
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allPages.values.elementAt(0).length,//allPages[1].length,
        itemBuilder: (BuildContext context, int index) {
          return PersonDelegate(
            data: allPages.values.elementAt(0)[index],
            onPressed: () {
              Navigator.pushNamed(context, '/room');
            },
          );
        });
  }
}