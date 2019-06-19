import 'package:flutter/material.dart';

import 'package:retroshare/ui/person_delegate.dart';

class _Page {
  _Page({this.label});
  final String label;
  String get id => label[0];
  @override
  String toString() => '$runtimeType("$label")';
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

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _allPages.length);
    _tabController.addListener(_handleTabSelection);
    _selectedTab = _tabController.index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: Text(_allPages.keys.elementAt(_selectedTab).label,
                    style: TextStyle(color: Colors.black)),
                pinned: true,
                expandedHeight: 150.0,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Colors.white,
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        sliver: SliverFixedExtentList(
                          itemExtent: PersonDelegate.delegateHeight,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final PersonDelegateData data =
                                  _allPages[page][index];
                              return PersonDelegate(
                                data: data,
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
            onPressed: () => setState(() {}),
            child: Icon(Icons.add, size: 35),
            backgroundColor: Colors.lightBlueAccent,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
