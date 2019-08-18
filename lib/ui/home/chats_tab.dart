import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/common/styles.dart';

import 'package:retroshare/model/chat.dart';
import 'package:retroshare/redux/model/app_state.dart';

class ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              StoreConnector<AppState, List<Chat>>(
                converter: (store) => store.state.subscribedChats,
                builder: (context, chatsList) {
                  return SliverPadding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 8, right: 16, bottom: 8),
                    sliver: SliverFixedExtentList(
                      itemExtent: personDelegateHeight,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/discover_chats');
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50 * 0.5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Discover public chats',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2,
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
                            final PersonDelegateData data = PersonDelegateData(
                              name: chatsList[index - 1].chatName,
                              mId: chatsList[index - 1].chatId.toString(),
                              isRoom: true,
                            );
                            return PersonDelegate(
                              data: data,
                              onPressed: () {
                                Navigator.pushNamed(context, '/room',
                                    arguments: {
                                      'isRoom': true,
                                      'chatData': chatsList[index - 1]
                                    });
                              },
                            );
                          }
                        },
                        childCount:
                            chatsList == null ? 1 : chatsList.length + 1,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          StoreConnector<AppState, List<Chat>>(
            converter: (store) => store.state.subscribedChats,
            builder: (context, chatsList) {
              if (chatsList.isEmpty)
                return Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/icons8/pluto-sign-in.png'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: Text(
                            "Looks like there aren't any subscribed chats",
                            style: Theme.of(context).textTheme.body2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              else
                return Container();
            },
          ),
        ],
      ),
    );
  }
}
