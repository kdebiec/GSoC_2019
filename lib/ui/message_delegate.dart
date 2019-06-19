import 'package:flutter/material.dart';

class MessageDelegateData {
  const MessageDelegateData(
      {this.name,
      this.message,
      this.time = '2 sec',
      this.profileImage = 'assets/profile.jpg',
      this.isOnline = true,
      this.isSent = false});
  final String name;
  final String message;
  final String time;
  final String profileImage;
  final bool isOnline;
  final bool isSent;
}

class MessageDelegate extends StatelessWidget {
  const MessageDelegate({this.data});

  final MessageDelegateData data;

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
                data.message,
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
