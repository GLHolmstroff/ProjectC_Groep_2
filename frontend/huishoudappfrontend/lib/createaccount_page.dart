import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart' as auth;
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'login_page.dart';
import 'main.dart';


class CreateAccount extends StatefulWidget {
  static String tag = 'createaccount-page';
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  FormType _formType = FormType.register;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Dispose of textcontroller after use to save resources
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    // if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            emailController.text.toString(),
            passwordController.text.toString()
          );

          print('Signed in $userId');
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
            emailController.text.toString(),
            passwordController.text.toString()
          );
          print('Registered in $userId');
        }
      } catch (e) {
        print(e);
      }
    // }
  }

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
      controller: emailController,
      validator: EmailValidator.validate,
      onSaved: (input) => _email = input,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordInput = TextFormField(
      controller: passwordController,
      validator: PasswordValidator.validate,
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
        onPressed: ()  async{
          submit();
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
        key: formKey,
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
