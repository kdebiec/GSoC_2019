import 'package:flutter/material.dart';
import 'package:retroshare/common/styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            Container(
              height: appBarHeight,
              child: Row(
                children: <Widget>[
                  Container(
                    width: personDelegateHeight,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: 'search_box',
                      child: Material(
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFF5F5F5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.symmetric(horizontal: 8),
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
                                    autofocus: true,
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
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Visibility(
                    visible: true,
                    child: Center(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                  'assets/icons8/pluto-done.png'),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                child: Text('Write something in the top bar',
                                    style: Theme.of(context).textTheme.body2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
