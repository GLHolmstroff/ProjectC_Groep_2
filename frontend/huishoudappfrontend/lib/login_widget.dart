import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() {
     _LoginPageState s = _LoginPageState();
    //  s.switchFormState("login");
     return s;
  }
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  FormType _formType = FormType.login;

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
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        print(_formType);
        if (_formType == FormType.login){
          String userId = await auth.signInWithEmailAndPassword(
            _email,
            _password,
          );
          final response = await get("http://10.0.2.2:8080/authRegister?uid=$userId");
          if (response.statusCode == 200){
            print("Succesfully Registered");
          }else{
            print("Connection Failed");
          }
          print('Signed in $userId');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
            _email,
            _password,
          );

          print('Signed in $userId');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void switchFormState(String state) {
    // formKey.currentState.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget variables
    final logo = Image.asset(
      'images/testlogoapp.png',
      width: 150,
      height: 180,
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: EmailValidator.validate,
      onSaved: (value) => _email = value,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      validator: PasswordValidator.validate,
      onSaved: (value) => _password = value,
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
        onPressed: submit,
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final googleLogIn = SignInButton(
      Buttons.Google,
      text: 'Log in met je Google account',
      onPressed: () async {
        try {
          final _auth = Provider.of(context).auth;
          final id = await _auth.signInWithGoogle();
          final response = await get("http://10.0.2.2:8080/authRegister?uid=$id");
          if (response.statusCode == 200){
            print("Succesfully Registered");
          }else{
            print("Connection Failed");
          }
        } catch (e) {
          print(e);
        }
      },
    );

    final signIn = FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CreateAccount.tag);
      },
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
        child: Form(
          key: formKey,
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
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
