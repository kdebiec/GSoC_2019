import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Screen'),
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
                  //onTap: () => onPressed(),
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.chat_bubble_outline,
                            color: Colors.lightBlueAccent, size: 30)
                      ],
                    ),
                  ),
                ),
              ),
                SizedBox(
                  width: 74
                ),
              Expanded(
                child: GestureDetector(
                  //onTap: () => onPressed(),
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.people_outline,
                            color: Colors.lightBlueAccent, size: 30)
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
      floatingActionButton: Container (
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => setState(() {}),
            child: Icon(Icons.add, size: 35),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
