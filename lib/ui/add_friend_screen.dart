import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/common/bottom_bar.dart';
import 'package:retroshare/services/account.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  TextEditingController ownCertController = TextEditingController();
  TextEditingController newCertController = TextEditingController();

  String ownCert;

  @override
  void initState() {
    super.initState();
    _getCert();
  }

  _getCert() async {
    ownCert = (await getOwnCert()).replaceAll("\n", "");
    ownCertController.text = ownCert;
  }

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
                    child: Visibility(
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
                  ),
                  Expanded(
                    child: Text(
                      'Add friend',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFF5F5F5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextField(
                                      readOnly: true,
                                      controller: ownCertController,
                                      keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xFFF5F5F5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextField(
                                      controller: newCertController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Your friend\'s certificate'),
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            BottomBar(
              child: Center(
                child: SizedBox(
                  height: 2 * appBarHeight / 3,
                  child: FlatButton(
                    onPressed: () async {
                      bool success = await addCert(newCertController.text);
                      if(success)
                        Navigator.pop(context);
                      else
                        showToast('An error occurred while adding your friend.');
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0 + personDelegateHeight * 0.04),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF00FFFF),
                              Color(0xFF29ABE2),
                            ],
                            begin: Alignment(-1.0, -4.0),
                            end: Alignment(1.0, 4.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Add friend',
                          style: Theme.of(context).textTheme.button,
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}