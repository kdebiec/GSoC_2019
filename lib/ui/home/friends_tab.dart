import 'package:flutter/material.dart';

import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/model/home_tabs.dart';
import 'package:retroshare/common/styles.dart';

class FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 8),
            sliver: SliverFixedExtentList(
              itemExtent: personDelegateHeight,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final PersonDelegateData data =
                      allPages.values.elementAt(1)[index];
                  return PersonDelegate(
                    data: data,
                    onPressed: () {
                      Navigator.pushNamed(context, '/room');
                    },
                  );
                },
                childCount: allPages.values.elementAt(1).length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
