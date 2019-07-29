import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/common/styles.dart';
import 'package:retroshare/common/bottom_bar.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/identity.dart';
import 'package:retroshare/redux/model/identity_state.dart';
import 'package:retroshare/redux/actions/identity_actions.dart';

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
                      'Create identity',
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
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 300 * 0.7,
                                  width: 300 * 0.7,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(300 * 0.7 * 0.33),
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage('assets/profile.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
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
                      Identity id = await createIdentity(Identity('', false, nameController.text));
                      final store = StoreProvider.of<IdentityState>(context);
                      store.dispatch(ChangeCurrentIdentityAction(id));

                      List<Identity> ownIdsList = await getOwnIdentities();
                      store.dispatch(UpdateIdentitiesAction(ownIdsList));

                      Navigator.pop(context);
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
                          'Create identity',
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
