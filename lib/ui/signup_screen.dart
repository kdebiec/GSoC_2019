import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool advancedOption;

  @override
  void initState() {
    super.initState();
    advancedOption = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/rs-logo.png', height: 250, width: 250),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Login'),
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Password'),
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Repeat password'),
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        advancedOption = !advancedOption;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: Color(0xFFF5F5F5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      height: 45,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: advancedOption,
                            onChanged: (bool value) {
                              setState(() {
                                advancedOption = value;
                              });
                            },
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Advanced option',
                            style: Theme.of(context).textTheme.body1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(height: 10),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF5F5F5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.smartphone,
                              color: Color(0xFF9E9E9E),
                              size: 22.0,
                            ),
                            hintText: 'Node name'),
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(height: 10),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          //color: Color(0xFFF5F5F5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: true,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Tor/I2p Hidden node',
                              style: Theme.of(context).textTheme.body1,
                            )
                          ],
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
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
                      child: const Text(
                        'Create account',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
