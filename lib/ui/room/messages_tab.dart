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
  List<Message> msgList = List();
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
          child: Stack(
            children: <Widget>[
              ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: msgList == null ? 0 : msgList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageDelegate(
                    data: msgList[index],
                  );
                },
              ),
              Visibility(
                visible: msgList.isEmpty,
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/icons8/pluto-no-messages-1.png'),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: Text('It seems like there is no messages',
                                style: Theme.of(context).textTheme.body2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
