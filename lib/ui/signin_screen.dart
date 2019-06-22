import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: <Widget>[
              Expanded(
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
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 30),
                    FlatButton(
                      onPressed: () {
                        //Navigator.pushReplacementNamed(context, '/home');
                        Navigator.pushNamed(context, '/home');
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
                            'Login',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      textColor: Color(0xFF9E9E9E),
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'Import account',
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      textColor: Color(0xFF9E9E9E),
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'Create account',
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
