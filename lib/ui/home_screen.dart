import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;

import 'package:retroshare/common/button.dart';
import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/person_delegate.dart';

class _Page {
  _Page({this.label});
  final String label;
  String get id => label[0];
  @override
  String toString() => '$runtimeType("$label")';
}

const double _kAppBarMinHeight = 150.0;
const double _kAppBarMidHeight = 256.0;

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  String toString() => '_SliverAppBarDelegate';
}

class _SnappingScrollPhysics extends ClampingScrollPhysics {
  const _SnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.minScrollOffset,
    @required this.midScrollOffset,
  })  : assert(minScrollOffset != null),
        assert(midScrollOffset != null),
        super(parent: parent);

  final double minScrollOffset;
  final double midScrollOffset;

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _SnappingScrollPhysics(
        parent: buildParent(ancestor),
        minScrollOffset: minScrollOffset,
        midScrollOffset: midScrollOffset);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  Simulation _toMinScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, minScrollOffset, velocity,
        tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double dragVelocity) {
    final Simulation simulation =
        super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      if (dragVelocity > 0.0)
        return _toMinScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      if (offset > 0.0 && offset < midScrollOffset)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);

      return _toMinScrollOffsetSimulation(offset, dragVelocity);
    }

    return simulation;
  }
}

final Map<_Page, List<PersonDelegateData>> _allPages =
    <_Page, List<PersonDelegateData>>{
  _Page(label: 'Chats'): <PersonDelegateData>[
    const PersonDelegateData(
      name: 'Sandie Gloop',
    ),
    const PersonDelegateData(
      name: 'May Doris Sparrow',
    ),
    const PersonDelegateData(
      name: 'Best room ever!',
    ),
    const PersonDelegateData(
      name: 'Andrew Walker',
    ),
    const PersonDelegateData(
      name: 'Do you feel that vibe?',
    ),
    const PersonDelegateData(
      name: 'Alison Platt',
    ),
    const PersonDelegateData(
      name: 'Ocean Greenwald',
    ),
    const PersonDelegateData(
      name: 'May Doris Sparrow',
    ),
    const PersonDelegateData(
      name: 'Best room ever!',
    ),
    const PersonDelegateData(
      name: 'Andrew Walker',
    ),
    const PersonDelegateData(
      name: 'Do you feel that vibe?',
    ),
    const PersonDelegateData(
      name: 'Alison Platt',
    ),
    const PersonDelegateData(
      name: 'Ocean Greenwald',
    ),
  ],
  _Page(label: 'Friends'): <PersonDelegateData>[
    const PersonDelegateData(
      name: 'Alison Platt',
    ),
    const PersonDelegateData(
      name: 'Harriet Rabbit',
    ),
    const PersonDelegateData(
      name: 'Helen Parker',
    ),
  ],
};

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedTab;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _allPages.length);
    _tabController.addListener(_handleTabSelection);
    _selectedTab = _tabController.index;

    _scrollController =
        ScrollController(initialScrollOffset: screenHeight - _kAppBarMinHeight)
          ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTab = _tabController.index;
    });
  }

  double get _getOffset {
    if (_scrollController.hasClients) {
      return _scrollController.offset;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    final double screenHeight = mediaQueryData.size.height;
    final double appBarMinHeight = _kAppBarMinHeight - statusBarHeight;
    final double appBarMaxHeight = appBarMinHeight +
        (screenHeight - statusBarHeight) * 0.15 +
        5 * buttonHeight;
    final double appBarMidScrollOffset =
        statusBarHeight + appBarMaxHeight - _kAppBarMidHeight;

    double heightOfTopBar = _getOffset == null
        ? appBarMinHeight
        : appBarMinHeight +
            math.sin((math.pi / 2) *
                    ((appBarMaxHeight * 0.9 - _getOffset) /
                        appBarMaxHeight *
                        0.9)) *
                appBarMaxHeight *
                0.15;
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        physics: _SnappingScrollPhysics(
            minScrollOffset: appBarMaxHeight,
            midScrollOffset: appBarMidScrollOffset * 0.5),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: _kAppBarMinHeight,
                  maxHeight: appBarMaxHeight,
                  child: Container(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
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
                                            : _getOffset <
                                                appBarMaxHeight * 0.2,
                                        child: Button(
                                            name: 'Create new identity',
                                            buttonIcon: Icons.add,
                                            onPressed: () {
                                              print('hello');
                                            }),
                                      ),
                                      Visibility(
                                        visible: _getOffset == null
                                            ? false
                                            : _getOffset <
                                                appBarMaxHeight * 0.3,
                                        child: Button(
                                            name: 'Delete identity',
                                            buttonIcon: Icons.delete),
                                      ),
                                      Visibility(
                                        visible: _getOffset == null
                                            ? false
                                            : _getOffset <
                                                appBarMaxHeight * 0.4,
                                        child: Button(
                                            name: 'Options',
                                            buttonIcon: Icons.settings),
                                      ),
                                      Visibility(
                                        visible: _getOffset == null
                                            ? false
                                            : _getOffset <
                                                appBarMaxHeight * 0.5,
                                        child: Button(
                                            name: 'About',
                                            buttonIcon: Icons.info),
                                      ),
                                      Visibility(
                                        visible: _getOffset == null
                                            ? false
                                            : _getOffset <
                                                appBarMaxHeight * 0.6,
                                        child: Button(
                                            name: 'Log out',
                                            buttonIcon: Icons.exit_to_app),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Text(
                                                    _allPages.keys
                                                        .elementAt(_selectedTab)
                                                        .label,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .title),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Center(
                                                child: Container(
                                                  width: (heightOfTopBar - 40) *
                                                      0.65,
                                                  height:
                                                      (heightOfTopBar - 40) *
                                                          0.65,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            (heightOfTopBar -
                                                                    40) *
                                                                0.8 *
                                                                0.5),
                                                    image: DecorationImage(
                                                      fit: BoxFit.fitWidth,
                                                      image: AssetImage(
                                                          'assets/profile.jpg'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
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
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(0xFFF5F5F5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
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
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Type text...'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .body2,
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
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _allPages.keys.map<Widget>((_Page page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<_Page>(page),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 8, right: 16, bottom: 8),
                        sliver: SliverFixedExtentList(
                          itemExtent: personDelegateHeight,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final PersonDelegateData data =
                                  _allPages[page][index];
                              return PersonDelegate(
                                data: data,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/room');
                                },
                              );
                            },
                            childCount: _allPages[page].length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(0);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.chat_bubble_outline,
                            color: _selectedTab == 0
                                ? Colors.lightBlueAccent
                                : Colors.black12,
                            size: 30)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 74),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(1);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.people_outline,
                            color: _selectedTab == 1
                                ? Colors.lightBlueAccent
                                : Colors.black12,
                            size: 30)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create_room');
            },
            child: Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
