import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var x = 0;
  increase() {
    setState(() {
      x++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'images/testlogoapp.png',
      width: 150,
      height: 180,
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Gebruikersnaam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Wachtwoord',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final googleLogIn = SignInButton(
      Buttons.Google,
      onPressed: increase,
    );

    final signIn = FlatButton(
      onPressed: increase,
      child: Text(
        'Account aanmaken',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            SizedBox(height: 70),
            logo,
            SizedBox(height: 50),
            email,
            SizedBox(height: 10),
            password,
            SizedBox(height: 10),
            loginButton,
            googleLogIn,
            SizedBox(height: 8),
            SizedBox(height: 40),
            signIn,
          ],
        ),
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
