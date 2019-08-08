import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:math' as math;
import 'dart:convert';

import 'package:retroshare/common/button.dart';
import 'package:retroshare/common/styles.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class TopBar extends StatefulWidget {
  final ScrollController scrollController;
  final TabController tabController;

  TopBar({Key key, this.scrollController, this.tabController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin {
  Animation<double> _leftHeaderFadeAnimation;
  Animation<double> _leftHeaderOffsetAnimation;
  Animation<double> _leftHeaderScaleAnimation;
  Animation<double> _rightHeaderFadeAnimation;
  Animation<double> _rightHeaderOffsetAnimation;
  Animation<double> _rightHeaderScaleAnimation;

  Animation<double> _headerFadeAnimation;

  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    widget.scrollController
      ..addListener(() => setState(() {
            if (widget.scrollController.offset >= 0 &&
                widget.scrollController.offset <=
                    (screenHeight - statusBarHeight) * 0.15 +
                        4 * buttonHeight -
                        statusBarHeight +
                        50)
              _animationController.value = 1 -
                  (widget.scrollController.offset /
                      ((screenHeight - statusBarHeight) * 0.15 +
                          4 * buttonHeight -
                          statusBarHeight));
          }));

    _leftHeaderFadeAnimation = Tween(
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

    _rightHeaderFadeAnimation = Tween(
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

    _headerFadeAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_curvedAnimation);
  }

  double get _getOffset {
    if (widget.scrollController.hasClients) {
      return widget.scrollController.offset;
    } else
      return 0;
  }

  void _showDialog() {
    final store = StoreProvider.of<AppState>(context);
    String name = store.state.currId.name;
    if (store.state.ownIdsList.length > 1)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete '$name'?"),
            content: Text(
                "The deletion of identity cannot be undone. Are you sure you want to continue?"),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () async {
                  bool success = await deleteIdentity(store.state.currId);

                  if (success) {
                    List<Identity> ownIdsList = await getOwnIdentities();
                    final store = StoreProvider.of<AppState>(context);
                    store.dispatch(UpdateOwnIdentitiesAction(ownIdsList));

                    Navigator.pushReplacementNamed(context, '/change_identity');
                  }
                },
              ),
            ],
          );
        },
      );
    else
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Too few identities"),
            content: Text(
                "You must have at least one more identity to be able to delete this one."),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  Widget getHeaderBuilder(BuildContext context, Widget widget) {
    return Container(
      child: FadeTransition(
        opacity: _headerFadeAnimation,
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
                  opacity: _leftHeaderFadeAnimation,
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
                  opacity: _rightHeaderFadeAnimation,
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
        4 * buttonHeight;

    double heightOfTopBar = _getOffset == null
        ? appBarMinHeight
        : appBarMinHeight +
            math.sin((math.pi / 2) *
                    ((appBarMaxHeight * 0.9 - _getOffset) /
                        appBarMaxHeight *
                        0.9)) *
                appBarMaxHeight *
                0.15 +
            _curvedAnimation.value * 50;

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
                              : _getOffset < appBarMaxHeight * 0.3,
                          child: Button(
                            name: 'Create new identity',
                            buttonIcon: Icons.add,
                            onPressed: () {
                              Navigator.pushNamed(context, '/create_identity');
                            },
                          ),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.4,
                          child: Button(
                            name: 'Change identity',
                            buttonIcon: Icons.visibility,
                            onPressed: () {
                              Navigator.pushNamed(context, '/change_identity');
                            },
                          ),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.4,
                          child: Button(
                            name: 'Delete identity',
                            buttonIcon: Icons.delete,
                            onPressed: () {
                              _showDialog();
                            },
                          ),
                        ),
                        Visibility(
                          visible: _getOffset == null
                              ? false
                              : _getOffset < appBarMaxHeight * 0.7,
                          child: Button(
                            name: 'Options',
                            buttonIcon: Icons.settings,
                            onPressed: () {
                              Navigator.pushNamed(context, '/settings');
                            },
                          ),
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
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: StoreConnector<AppState, String>(
                                    converter: (store) =>
                                        store.state.currId.avatar,
                                    builder: (context, avatar) {
                                      return Container(
                                        width: (heightOfTopBar - 40) * 0.65,
                                        height: (heightOfTopBar - 40) * 0.65,
                                        decoration: avatar.isEmpty
                                            ? null
                                            : BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        (heightOfTopBar - 40) *
                                                            0.65 *
                                                            0.33),
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: MemoryImage(
                                                      base64.decode(avatar)),
                                                ),
                                              ),
                                        child: Visibility(
                                          visible: avatar.isEmpty,
                                          child: Center(
                                            child: Icon(
                                              Icons.person,
                                              size:
                                                  (heightOfTopBar - 40) * 0.65,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                                    child: AnimatedBuilder(
                                      animation: _curvedAnimation,
                                      builder: (BuildContext context,
                                          Widget widget) {
                                        return FadeTransition(
                                          opacity: _headerFadeAnimation,
                                          child: IconButton(
                                            icon: Icon(Icons.person_add,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .body2
                                                    .color),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed('/add_friend');
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _curvedAnimation,
                          builder: (BuildContext context, Widget widget) {
                            return StoreConnector<AppState, String>(
                              converter: (store) => store.state.currId.name,
                              builder: (context, idName) {
                                return Center(
                                  child: Container(
                                    height: 50 * _curvedAnimation.value,
                                    child: Center(
                                      child: ScaleTransition(
                                        scale: _curvedAnimation,
                                        child: FadeTransition(
                                          opacity: _curvedAnimation,
                                          child: Text(
                                            idName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .title,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
