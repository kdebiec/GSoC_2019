import 'package:flutter/material.dart';

class _Page {
  _Page({this.label});
  final String label;
  String get id => label[0];
  @override
  String toString() => '$runtimeType("$label")';
}

class _CardData {
  const _CardData({this.title});
  final String title;
}

final Map<_Page, List<_CardData>> _allPages = <_Page, List<_CardData>>{
  _Page(label: 'Chats'): <_CardData>[
    const _CardData(
      title: 'Sandie Gloop',
    ),
    const _CardData(
      title: 'May Doris Sparrow',
    ),
    const _CardData(
      title: 'Best room ever!',
    ),
    const _CardData(
      title: 'Andrew Walker',
    ),
    const _CardData(
      title: 'Do you feel that vibe?',
    ),
    const _CardData(
      title: 'Alison Platt',
    ),
    const _CardData(
      title: 'Ocean Greenwald',
    ),
  ],
  _Page(label: 'Friends'): <_CardData>[
    const _CardData(
      title: 'Alison Platt',
    ),
    const _CardData(
      title: 'Harriet Rabbit',
    ),
    const _CardData(
      title: 'Helen Parker',
    ),
  ],
};

class _CardDataItem extends StatelessWidget {
  const _CardDataItem({this.page, this.data});

  static const double height = 100.0;
  final _Page page;
  final _CardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Text(
          data.title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}

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
                          itemExtent: _CardDataItem.height,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final _CardData data = _allPages[page][index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: _CardDataItem(
                                  page: page,
                                  data: data,
                                ),
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
