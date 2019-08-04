import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/common/bottom_bar.dart';
import 'package:retroshare/ui/person_delegate.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/services/chat.dart';

import 'package:retroshare/redux/model/app_state.dart';

final List<PersonDelegateData> personData = [
  const PersonDelegateData(
    name: 'Alison Platt',
  ),
  const PersonDelegateData(
    name: 'Harriet Rabbit',
  ),
  const PersonDelegateData(
    name: 'Helen Parker',
  ),
  const PersonDelegateData(
    name: 'Alison Platt',
  ),
  const PersonDelegateData(
    name: 'Harriet Rabbit',
  ),
  const PersonDelegateData(
    name: 'Helen Parker',
  ),
  const PersonDelegateData(
    name: 'Alison Platt',
  ),
  const PersonDelegateData(
    name: 'Harriet Rabbit',
  ),
  const PersonDelegateData(
    name: 'Helen Parker',
  ),
];

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inviteFriendsController =
      TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomTopicController = TextEditingController();
  bool isPublic;
  bool isAnonymous;

  bool _isRoomCreation;
  Animation<double> _fadeAnimation;
  Animation<double> _heightAnimation;
  Animation<double> _buttonHeightAnimation;
  Animation<double> _buttonFadeAnimation;
  AnimationController _animationController;

  Animation<Color> _doneButtonColor;
  AnimationController _doneButtonController;

  @override
  void initState() {
    super.initState();
    _isRoomCreation = false;
    isPublic = true;
    isAnonymous = true;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _doneButtonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _roomNameController.addListener(() {
      if (_isRoomCreation && _roomNameController.text.length > 2)
        _doneButtonController.forward();
      else
        _doneButtonController.reverse();
    });

    _fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _heightAnimation = Tween(
      begin: 40.0,
      end: 5 * 40.0 + 3 * 8.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _buttonHeightAnimation = Tween(
      begin: personDelegateHeight,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _buttonFadeAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.75,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _doneButtonColor =
        ColorTween(begin: Color(0xFF9E9E9E), end: Colors.black).animate(
      CurvedAnimation(
        parent: _doneButtonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _inviteFriendsController.dispose();
    _roomNameController.dispose();
    _roomTopicController.dispose();
    _animationController.dispose();
    _doneButtonController.dispose();

    super.dispose();
  }

  void _onGoBack() {
    if (_isRoomCreation) {
      _animationController.reverse();
      setState(() {
        _isRoomCreation = false;
      });
    } else
      Navigator.pop(context);
  }

  void _createChat() async {
    final store = StoreProvider.of<AppState>(context);
    if (_isRoomCreation)
      createChatLobby(_roomNameController.text, store.state.currId.mId,
          _roomTopicController.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onGoBack();
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: appBarHeight,
                      width: personDelegateHeight,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 25,
                        ),
                        onPressed: () {
                          _onGoBack();
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget widget) {
                            return Container(
                              height: _heightAnimation.value,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 4 * 40.0 + 3 * 8,
                                      width: double.infinity,
                                      child: FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Visibility(
                                              visible: _heightAnimation.value >=
                                                  4 * 40.0 + 3 * 8,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Color(0xFFF5F5F5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 40,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              _roomNameController,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Room name'),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .body2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Visibility(
                                              visible: _heightAnimation.value >=
                                                  3 * 40.0 + 3 * 8,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Color(0xFFF5F5F5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                height: 40,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              _roomTopicController,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Room topic'),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .body2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isPublic = !isPublic;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  height: 40,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: isPublic,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            isPublic = value;
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        'Public',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isAnonymous = !isAnonymous;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  height: 40,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        value: isAnonymous,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            isAnonymous = value;
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        'Accessible to anonymous',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFF5F5F5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    height: 40,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Invite friends...'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: appBarHeight,
                      child: AnimatedBuilder(
                        animation: _doneButtonController,
                        builder: (BuildContext context, Widget widget) {
                          return IconButton(
                            icon: Icon(
                              Icons.done,
                              size: 25,
                            ),
                            color: _doneButtonColor.value,
                            onPressed: () {
                              _createChat();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 8, top: 0, right: 16, bottom: 8),
                  itemCount: personData.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget widget) {
                            return GestureDetector(
                              onTap: () {
                                _animationController.forward();
                                setState(() {
                                  _isRoomCreation = true;
                                });
                              },
                              child: Container(
                                color: Colors.white,
                                height: _buttonHeightAnimation.value,
                                child: FadeTransition(
                                  opacity: _buttonFadeAnimation,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: _buttonHeightAnimation.value,
                                        width: personDelegateHeight,
                                        child: Center(
                                          child: Icon(Icons.add,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .body2
                                                  .color),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Create new room',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body2),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }

                    index -= 1;

                    return PersonDelegate(
                      data: personData[index],
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
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type text...'),
                            style: Theme.of(context).textTheme.body2,
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
      ),
    );
  }
}
