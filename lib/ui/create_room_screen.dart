import 'package:flutter/material.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/ui/person_delegate.dart';

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

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final double appBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: appBarHeight + 32 + 8,
            padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: personDelegateHeight,
                  width: personDelegateHeight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 25,
                    ),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
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
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Invite friend...'),
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    size: 25,
                  ),
                  color: Color(0xFF9E9E9E),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(left: 8, top: 0, right: 16, bottom: 8),
              itemCount: personData == null ? 1 : personData.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return GestureDetector(
                    child: Container(
                      height: personDelegateHeight,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: personDelegateHeight,
                            width: personDelegateHeight,
                            child: Center(
                              child: Icon(Icons.add,
                                  color:
                                      Theme.of(context).textTheme.body2.color),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Create new room',
                                      style: Theme.of(context).textTheme.body2),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                index -= 1;
                return PersonDelegate(
                  data: personData[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          height: appBarHeight + 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(appBarHeight / 3),
              topRight: Radius.circular(appBarHeight / 3),
            ),
            color: Colors.white,
          ),
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type text...'),
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.face,
                            ),
                            color: Color(0xFF9E9E9E),
                            onPressed: () {},
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
      ),
    );
  }
}
