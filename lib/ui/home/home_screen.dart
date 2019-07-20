import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;

import 'package:retroshare/ui/home/topbar.dart';
import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/person_delegate.dart';

import 'package:retroshare/model/home_tabs.dart';

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
    @required this.maxScrollOffset,
  })  : assert(maxScrollOffset != null),
        super(parent: parent);

  final double maxScrollOffset; // TopBar have the smallest size

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _SnappingScrollPhysics(
        parent: buildParent(ancestor), maxScrollOffset: maxScrollOffset);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  Simulation _toMaxScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, maxScrollOffset, velocity,
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
        return _toMaxScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0 )
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }

    if (offset <= maxScrollOffset / 2)
      return _toZeroScrollOffsetSimulation(offset, dragVelocity);

    return _toMaxScrollOffsetSimulation(offset, dragVelocity);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  ScrollController _scrollController;

  Animation<Color> _leftIconAnimation;
  Animation<Color> _rightIconAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: allPages.length);

    _scrollController =
        ScrollController(initialScrollOffset: screenHeight - kAppBarMinHeight);

    _scrollController.addListener(() {
      if (_scrollController.offset < kAppBarMinHeight) {
        setState(() {});
      }
    });

    _leftIconAnimation =
        ColorTween(begin: Colors.lightBlueAccent, end: Colors.black12)
            .animate(_tabController.animation);

    _rightIconAnimation =
        ColorTween(begin: Colors.black12, end: Colors.lightBlueAccent)
            .animate(_tabController.animation);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget getLeftIconBuilder(BuildContext context, Widget widget) {
    return Icon(Icons.chat_bubble_outline,
        color: _leftIconAnimation.value, size: 30);
  }

  Widget getRightIconBuilder(BuildContext context, Widget widget) {
    return Icon(Icons.people_outline,
        color: _rightIconAnimation.value, size: 30);
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
    final double appBarMidScrollOffset =
        statusBarHeight + appBarMaxHeight - kAppBarMidHeight;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        physics: _SnappingScrollPhysics(maxScrollOffset: appBarMaxHeight-appBarMinHeight),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: kAppBarMinHeight,
                  maxHeight: appBarMaxHeight,
                  child: TopBar(
                      scrollController: _scrollController,
                      tabController: _tabController),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: allPages.keys.map<Widget>((Page page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<Page>(page),
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
                                  allPages[page][index];
                              return PersonDelegate(
                                data: data,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/room');
                                },
                              );
                            },
                            childCount: allPages[page].length,
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
                        AnimatedBuilder(
                          animation: _tabController.animation,
                          builder: getLeftIconBuilder,
                        ),
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
                        AnimatedBuilder(
                          animation: _tabController.animation,
                          builder: getRightIconBuilder,
                        ),
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
