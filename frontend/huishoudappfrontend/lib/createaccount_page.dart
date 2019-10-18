import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/home_page.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart' as auth;
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_import 'package:http/http.dart';

import 'package:toast/toast.dart';


import 'login_page.dart';

class CreateAccount extends StatefulWidget {
  static String tag = 'createaccount-page';
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  //Dispose of textcontroller after use to save resources
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
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

  bool checkPasswords() {
    if (passwordController.text.toString() ==
        passwordCheckController.text.toString()) {
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (checkPasswords()) {
          String userId = await auth.createUserWithEmailAndPassword(
            _email,
            _password,
          );
          final response = await get("http://seprojects.nl:8080/authRegister?uid=$userId");
          if (response.statusCode == 200){
            print("Succesfully Registered");
          }else{
            print("Connection Failed");
          }

          print('Registered in $userId');
          Toast.show("account aangemaakt", context);
          //Navigator.of(context).pushNamed(LoginPage.tag);
          Navigator.pop(context);
        } else {
          Toast.show('Wachtwoorden komen niet overeen', context);
          print("Account not created due to passwords incorrection");
        }
      } catch (e) {
        print(e);
      }
    }
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
      onSaved: (value) => _email = value,
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
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value) => _password = value,
      decoration: InputDecoration(
        hintText: 'Wachtwoord',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordCheckInput = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: passwordCheckController,
      validator: PasswordValidator.validate,
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

        onPressed: submit,

        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Account aanmaken', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Form(
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
      ),
    );
  }
}
