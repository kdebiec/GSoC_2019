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
      child: Stack(
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
                      final PersonDelegateData data =
                          allPages.values.elementAt(1)[index];
                      return PersonDelegate(
                        data: data,
                        onPressed: () {
                          Navigator.pushNamed(context, '/room');
                        },
                      );
                    },
                    childCount: 0, //allPages.values.elementAt(1).length,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: true,
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
      ),
    );
  }
}
