import 'package:flutter/material.dart';

import 'package:retroshare/ui/room/message_delegate.dart';
import 'package:retroshare/common/styles.dart';

final List<MessageDelegateData> messageData = [
  const MessageDelegateData(
      name: 'Alison Platt',
      isSent: true,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Harriet Rabbit',
      isSent: false,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Helen Parker',
      isSent: true,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Alison Platt',
      isSent: true,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Harriet Rabbit',
      isSent: false,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Alison Platt',
      isSent: true,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
  const MessageDelegateData(
      name: 'Harriet Rabbit',
      isSent: false,
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi finibus nibh lacinia, placerat ligula in, aliquam est. Integer malesuada quam nec libero molestie efficitur. In cursus rhoncus nisi, '),
];

class MessagesTab extends StatefulWidget {
  @override
  _MessagesTabState createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16.0),
            itemCount: messageData.length,
            itemBuilder: (BuildContext context, int index) {
              return MessageDelegate(
                data: messageData[index],
              );
            },
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
    );
  }
}
