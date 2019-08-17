import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'dart:convert';

import 'package:retroshare/common/button.dart';
import 'package:retroshare/common/styles.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class TopBar extends StatefulWidget {
  final double maxHeight;
  final double minHeight;
  final double panelAnimationValue;
  final TabController tabController;

  TopBar(
      {Key key,
      this.maxHeight,
      this.minHeight,
      this.panelAnimationValue,
      this.tabController})
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
  Animation<double> _nameHeaderFadeAnimation;

  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic);

    _animationController.value = getPanelAnimationValue;

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

    _nameHeaderFadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.easeInCubic,
      ),
    ));
  }

  double get getPanelAnimationValue {
    return widget.panelAnimationValue;
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
    _animationController.value = getPanelAnimationValue;

    double heightOfTopBar = widget.minHeight +
        widget.panelAnimationValue *
            (widget.maxHeight - 3 * buttonHeight - widget.minHeight - 20);

    double heightOfNameHeader = 20 * _curvedAnimation.value;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: widget.minHeight +
                (widget.maxHeight - widget.minHeight) *
                    widget.panelAnimationValue,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: widget.panelAnimationValue,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Visibility(
                            visible: widget.panelAnimationValue == null
                                ? false
                                : widget.panelAnimationValue > 0.3,
                            child: Button(
                              name: 'Create new identity',
                              buttonIcon: Icons.add,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/create_identity');
                              },
                            ),
                          ),
                          Visibility(
                            child: Button(
                              name: 'Change identity',
                              buttonIcon: Icons.visibility,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/change_identity');
                              },
                            ),
                          ),
                          Visibility(
                            child: Button(
                              name: 'Delete identity',
                              buttonIcon: Icons.delete,
                              onPressed: () {
                                _showDialog();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 10,
                        color: Color.fromRGBO(
                            255, 255, 255, 1.0),
                        spreadRadius: 15,
                      )
                    ],
                  ),
                  height: heightOfTopBar + heightOfNameHeader,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                                      width: heightOfTopBar * 0.75,
                                      height: heightOfTopBar * 0.75,
                                      decoration: avatar.isEmpty
                                          ? null
                                          : BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      heightOfTopBar *
                                                          0.75 *
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
                                            size: heightOfTopBar * 0.75,
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
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AnimatedBuilder(
                                    animation: _curvedAnimation,
                                    builder:
                                        (BuildContext context, Widget widget) {
                                      return FadeTransition(
                                        opacity: _headerFadeAnimation,
                                        child: IconButton(
                                          icon: Icon(Icons.person_add,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .body2
                                                  .color,
                                              size: 30),
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
                        AnimatedBuilder(
                          animation: _curvedAnimation,
                          builder: (BuildContext context, Widget widget) {
                            return StoreConnector<AppState, String>(
                              converter: (store) => store.state.currId.name,
                              builder: (context, idName) {
                                return Center(
                                  child: Container(
                                    height: heightOfNameHeader * 2,
                                    child: Center(
                                      child: ScaleTransition(
                                        scale: _curvedAnimation,
                                        child: FadeTransition(
                                          opacity: _nameHeaderFadeAnimation,
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
