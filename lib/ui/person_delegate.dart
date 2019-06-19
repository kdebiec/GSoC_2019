import 'package:flutter/material.dart';

class PersonDelegateData {
  const PersonDelegateData(
      {this.name,
        this.message = 'Lorem ipsum dolor sit...',
        this.time = '2 sec',
        this.profileImage = 'assets/profile.jpg',
        this.isOnline = true,
        this.isMessage = false,
        this.isUnread = false});
  final String name;
  final String message;
  final String time;
  final String profileImage;
  final bool isOnline;
  final bool isMessage;
  final bool isUnread;
}

class PersonDelegate extends StatelessWidget {
  const PersonDelegate({this.data});

  static const double delegateHeight = 86.0;
  static const double width = 100.0;
  final PersonDelegateData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: delegateHeight,
      child: Row(
        children: <Widget>[
          Container(
            width: delegateHeight,
            height: delegateHeight,
            child: Stack(
              alignment: Alignment(-1.0, 0.0),
              children: <Widget>[
                Center(
                  child:
                  Visibility (
                    visible: data.isUnread,
                    child:Container(
                      height: delegateHeight * 0.92,
                      width: delegateHeight * 0.92,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF00FFFF),
                            Color(0xFF29ABE2),
                          ], // whitish to gray
                        ),
                        borderRadius:
                        BorderRadius.circular(delegateHeight * 0.92 * 0.33),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: data.isUnread
                        ? delegateHeight * 0.85
                        : delegateHeight * 0.8,
                    width: data.isUnread
                        ? delegateHeight * 0.85
                        : delegateHeight * 0.8,
                    decoration: BoxDecoration(
                      border: data.isUnread
                          ? Border.all(
                          color: Colors.white, width: delegateHeight * 0.03)
                          : null,
                      color: Colors.lightBlueAccent,
                      borderRadius:
                      BorderRadius.circular(delegateHeight * 0.8 * 0.33),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(data.profileImage),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: data.isOnline,
                  child: Positioned(
                    bottom: delegateHeight * 0.73,
                    left: delegateHeight * 0.73,
                    child: Container(
                      height: delegateHeight * 0.25,
                      width: delegateHeight * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white, width: delegateHeight * 0.03),
                        color: Colors.lightGreenAccent,
                        borderRadius:
                        BorderRadius.circular(delegateHeight * 0.3 * 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: data.isMessage
                        ? Theme.of(context).textTheme.body2
                        : Theme.of(context).textTheme.body1,
                  ),
                  Visibility(
                    visible: data.isMessage,
                    child: Text(
                      data.message,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(data.time, style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }
}