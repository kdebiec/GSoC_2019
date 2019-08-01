import 'package:flutter/material.dart';

import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/model/home_tabs.dart';
import 'package:retroshare/common/styles.dart';

class ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 8),
            sliver: SliverFixedExtentList(
              itemExtent: personDelegateHeight,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/discover_chats');
                      },
                      child: Container(
                        height: personDelegateHeight,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                              Radius.circular(appBarHeight / 3)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 50 * 0.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Discover public chats',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final PersonDelegateData data =
                        allPages.values.elementAt(0)[index - 1];
                    return PersonDelegate(
                      data: data,
                      onPressed: () {
                        Navigator.pushNamed(context, '/room');
                      },
                    );
                  }
                },
                childCount: allPages.values.elementAt(0).length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
