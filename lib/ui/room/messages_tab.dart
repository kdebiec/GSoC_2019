import 'package:flutter/material.dart';

import 'package:retroshare/ui/room/message_delegate.dart';
import 'package:retroshare/common/bottom_bar.dart';
import 'package:retroshare/model/chat.dart';
import 'package:retroshare/services/chat.dart';

class MessagesTab extends StatefulWidget {
  final Chat chat;

  MessagesTab({this.chat});

  @override
  _MessagesTabState createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  List<Message> msgList;
  TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16.0),
            itemCount: msgList == null ? 0 : msgList.length,
            itemBuilder: (BuildContext context, int index) {
              return MessageDelegate(
                data: msgList[index],
              );
            },
          ),
        ),
        BottomBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.image,
                  ),
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
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Type text...'),
                      style: Theme.of(context).textTheme.body2,
                      onSubmitted: (String msg) {
                        sendMessage(widget.chat.chatId, msg);
                        msgController.clear();
                      },
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
