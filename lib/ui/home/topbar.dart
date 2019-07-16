import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:retroshare/common/button.dart';
import 'package:retroshare/common/styles.dart';

import 'package:retroshare/model/home_tabs.dart';

class TopBar extends StatefulWidget {
  final ScrollController scrollController;
  final TabController tabController;

  TopBar({Key key, this.scrollController, this.tabController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  Animation<double> _leftHeaderSizeAnimation;
  Animation<double> _leftHeaderOffsetAnimation;
  Animation<double> _leftHeaderScaleAnimation;
  Animation<double> _rightHeaderSizeAnimation;
  Animation<double> _rightHeaderOffsetAnimation;
  Animation<double> _rightHeaderScaleAnimation;

  @override
  void initState() {
    super.initState();
    widget.scrollController..addListener(() => setState(() {}));

    _leftHeaderSizeAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(widget.tabController.animation);

    _leftHeaderOffsetAnimation = Tween(
      begin: 0.0,
      end: -60.0,
    ).animate(widget.tabController.animation);

    _leftHeaderScaleAnimation = Tween(
      begin: 1.0,
      end: 0.5,
    ).animate(widget.tabController.animation);

    _rightHeaderSizeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(widget.tabController.animation);

    _rightHeaderOffsetAnimation = Tween(
      begin: 60.0,
      end: 0.0,
    ).animate(widget.tabController.animation);

    _rightHeaderScaleAnimation = Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(widget.tabController.animation);
  }

  double get _getOffset {
    if (widget.scrollController.hasClients) {
      return widget.scrollController.offset;
    } else
      return null;
  }

  Widget getHeaderBuilder(BuildContext context, Widget widget) {
    return Container(
      child: Stack(
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
              _leftHeaderOffsetAnimation.value,
              0.0,
              0.0,
            ),
            child: ScaleTransition(
              scale: _leftHeaderScaleAnimation,
              child: FadeTransition(
                opacity: _leftHeaderSizeAnimation,
                child: Container(
                  child: Text(
                    'Chats',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
            ),
          ),
          Transform(
            transform: Matrix4.translationValues(
              _rightHeaderOffsetAnimation.value,
              0.0,
              0.0,
            ),
            child: ScaleTransition(
              scale: _rightHeaderScaleAnimation,
              child: FadeTransition(
                opacity: _rightHeaderSizeAnimation,
                child: Container(
                  child: Text(
                    'Friends',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    final double screenHeight = mediaQueryData.size.height;
    final double appBarMinHeight = kAppBarMinHeight - statusBarHeight;
    final double appBarMaxHeight = appBarMinHeight +
        (screenHeight - statusBarHeight) * 0.15 +
        5 * buttonHeight;

    double heightOfTopBar = _getOffset == null
        ? appBarMinHeight
        : appBarMinHeight +
            math.sin((math.pi / 2) *
                    ((appBarMaxHeight * 0.9 - _getOffset) /
                        appBarMaxHeight *
                        0.9)) *
                appBarMaxHeight *
                0.15;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: statusBarHeight,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 1,
                          ),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.2,
                          child: Button(
                              name: 'Create new identity',
                              buttonIcon: Icons.add,
                              onPressed: () {
                                Navigator.pushNamed(context, '/create_identity');
                              }),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.3,
                          child: Button(
                              name: 'Delete identity',
                              buttonIcon: Icons.delete),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.4,
                          child: Button(
                              name: 'Options', buttonIcon: Icons.settings),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.5,
                          child: Button(name: 'About', buttonIcon: Icons.info),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.6,
                          child: Button(
                              name: 'Log out', buttonIcon: Icons.exit_to_app),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: heightOfTopBar,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: AnimatedBuilder(
                                    animation: widget.tabController.animation,
                                    builder: getHeaderBuilder,
                                  ),
                                  /*Text(
                                      allPages.keys
                                          .elementAt(_selectedTab)
                                          .label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .title),*/
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: Container(
                                    width: (heightOfTopBar - 40) * 0.65,
                                    height: (heightOfTopBar - 40) * 0.65,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(
                                          (heightOfTopBar - 40) * 0.8 * 0.5),
                                      image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage('assets/profile.jpg'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.unfold_more,
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
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
                                  Icon(Icons.search,
                                      color: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .color),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type text...'),
                                      style: Theme.of(context).textTheme.body2,
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
