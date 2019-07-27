import 'package:flutter/material.dart';
import 'package:retroshare/common/styles.dart';

class BottomBar extends StatelessWidget {
  final Widget child;

  BottomBar({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(appBarHeight / 3),
            topRight: Radius.circular(appBarHeight / 3)),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
