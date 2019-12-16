import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart' as auth;
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import 'login_widget.dart';

class CreateAccount extends StatefulWidget {
  static String tag = 'createaccount-page';
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _displayname;
  bool _obscureText = true;
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
          final response =
              await get("http://10.0.2.2:8080/authRegister?uid=$userId");
          if (response.statusCode == 200) {
            print("Succesfully Registered");
            final Response res = await get(
                "http://10.0.2.2:8080/userUpdateDisplayName?uid=$userId&displayname=$_displayname",
                headers: {'Content-Type': 'application/json'});
            if (res.statusCode == 200) {
              print('displayname updated');
            } else {
              print('displayname niet geupdate');
            }
          } else {
            print("Connection Failed");
          }

          print('Registered in $userId');
          Toast.show(
            "account aangemaakt",
            context,
            duration: 2,
          );
          Navigator.pop(context);
        } else {
          Toast.show(
            'Wachtwoorden komen niet overeen',
            context,
            duration: 2,
            gravity: Toast.CENTER,
          );
          print("Account not created due to passwords incorrection");
        }
      } catch (e) {
        print(e);
        if (e.toString().contains("The email address is already in use")) {
          Toast.show(
            "Email al in gebruik",
            context,
            duration: 2,
            gravity: Toast.CENTER,
          );
        }
      }
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerText = Text(
      'Registreren',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.orange[700],
      ),
    );

    final usernameInput = TextFormField(
      validator: NameValidator.validate,
      onSaved: (value) => _displayname = value,
      decoration: InputDecoration(
        hintText: 'Gebruikersnaam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
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
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );

    final passwordInput = TextFormField(
      controller: passwordController,
      validator: PasswordValidator.validate,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value) => _password = value,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Wachtwoord',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'hide password' : 'show password',
            color: Colors.orange[700],
          ),
          onPressed: _toggle,
        ),
      ),
    );

    final passwordCheckInput = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: passwordCheckController,
      validator: PasswordValidator.validate,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Wachtwoord herhalen',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'hide password' : 'show password',
            color: Colors.orange[700],
          ),
          onPressed: _toggle,
        ),
      ),
    );

    final createAccountButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: submit,
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        child: Text('Account aanmaken', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              SizedBox(height: 70),
              registerText,
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  border: Border.all(
                    color: Colors.grey[200],
                    width: 2.0,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
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
            ],
          ),
        ),
      ),
    );
  }
}
