import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/login_page.dart';

import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  static String tag = 'createaccount-page';
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // The formkey contains the email and password entered by user
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    final registerText = Text(
      'Registreren',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
    );

    final usernameInput = TextFormField(
      decoration: InputDecoration(
        hintText: 'Gebruikersnaam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailInput = TextFormField(
      validator: (input) {
        if (input.isEmpty) {
          return 'Geen geldig email';
        }
      },
      onSaved: (input) => _email = input,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordInput = TextFormField(
      validator: (input) {
        if (input.length < 6) {
          return 'Wachtwoord moet minstens uit 6 tekens bestaan';
        }
      },
      onSaved: (input) => _password = input,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Wachtwoord',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordCheckInput = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: 'Wachtwoord herhalen',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final createAccountButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          Navigator.of(context).pushNamed(LoginPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Account aanmaken', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            SizedBox(height: 70),
            registerText,
            SizedBox(height: 80),
            usernameInput,
            SizedBox(height: 30),
            emailInput,
            SizedBox(height: 30),
            passwordInput,
            SizedBox(height: 30),
            passwordCheckInput,
            SizedBox(height: 50),
            createAccountButton,
          ],
        ),
      ),
    );
  }
}