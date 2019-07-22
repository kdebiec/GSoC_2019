import 'package:flutter/material.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/identity.dart';

class CreateIdentityScreen extends StatefulWidget {
  @override
  _CreateIdentityScreenState createState() => _CreateIdentityScreenState();
}

class _CreateIdentityScreenState extends State<CreateIdentityScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: appBarHeight + 32 + 8,
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 32.0, 16.0, 8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
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
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Create identity',
                                style: Theme.of(context).textTheme.body2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: Center(
                                    child: Container(
                                      height: 300 * 0.7,
                                      width: 300 * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            300 * 0.7 * 0.33),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image:
                                              AssetImage('assets/profile.jpg'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(0xFFF5F5F5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 40,
                                          child: TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  Icons.person_outline,
                                                  color: Color(0xFF9E9E9E),
                                                  size: 22.0,
                                                ),
                                                hintText: 'Name'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      FlatButton(
                                        onPressed: () {
                                          createIdentity(Identity('', nameController.text));
                                        },
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(0.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                            child: const Text(
                                              'Create identity',
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          );
        },
      ),
    );
  }
}
