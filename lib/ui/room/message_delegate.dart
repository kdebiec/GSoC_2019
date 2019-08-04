import 'package:flutter/material.dart';

import 'package:retroshare/model/chat.dart';

class MessageDelegate extends StatelessWidget {
  const MessageDelegate({this.data});

  final Message data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: FractionallySizedBox(
          alignment: data.isSent ? Alignment.centerRight : Alignment.centerLeft,
          widthFactor: 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: data.isSent ? Colors.blue : Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(80 / 3),
              gradient: data.isSent
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00FFFF),
                        Color(0xFF29ABE2),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                data.msgContent,
                style: TextStyle(
                  color: data.isSent ? Colors.white : Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
