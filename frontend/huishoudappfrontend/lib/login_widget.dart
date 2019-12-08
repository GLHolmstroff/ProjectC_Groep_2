import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';
import 'package:toast/toast.dart';

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
  final formKey1 = GlobalKey<FormState>();

  bool _obscureText = true;
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

  bool validateE() {
    final form = formKey1.currentState;
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
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            _email,
            _password,
          );
          final response =
              await get("http://10.0.2.2:8080/authRegister?uid=$userId");
          if (response.statusCode == 200) {
            print("Succesfully Registered");
          } else {
            print("Connection Failed");
          }
          print('Signed in $userId');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } catch (e) {
        print('deze $e');
        if (e.toString().contains("The password is invalid")) {
          Toast.show(
            "Wachtwoord ongeldig",
            context,
            duration: 2,
            gravity: Toast.CENTER,
          );
        }
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

  void _sendChangePasswordEmail() async {
    final auth = Provider.of(context).auth;
    if (validateE()) {
      try {
        await auth.sendResetPasswordEmail(_email);
        print("ResetEmail send");
        Navigator.pop(context);
      } catch (a) {
        print(a);
      }
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showDialog(String type) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(type),
          content: SingleChildScrollView(
            child: Form(
              key: formKey1,
              child: new TextFormField(
                keyboardType: TextInputType.text,
                validator: EmailValidator.validate,
                onSaved: (value) => _email = value,
                decoration: InputDecoration(
                  hintText: 'Jouw email',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.orange[700],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Verstuur",
                style: TextStyle(
                  color: Colors.orange[700],
                ),
              ),
              onPressed: () {
                _sendChangePasswordEmail();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget variables
    final logo = Image(
      image: AssetImage('images/beerphoto2.png'),
      fit: BoxFit.cover,
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: EmailValidator.validate,
      onSaved: (value) => _email = value,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.orange[700]),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      validator: PasswordValidator.validate,
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

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: submit,
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        child: Text(
          'Log In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final googleLogIn = SignInButton(
      Buttons.Google,
      text: 'Log in met je Google account',
      onPressed: () async {
        try {
          final _auth = Provider.of(context).auth;
          final id = await _auth.signInWithGoogle();
          final response =
              await get("http://10.0.2.2:8080/authRegister?uid=$id");
          if (response.statusCode == 200) {
            print("Succesfully Registered");
          } else {
            print("Connection Failed");
          }
        } catch (e) {
          print(e);
        }
      },
    );

    /*final signIn = FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CreateAccount.tag);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.all(12),
      child: Text(
        'Account aanmaken',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.white,
        ),
      ),
      color: Colors.orange[700],
    );*/

    final createAccount = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateAccount.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        child: Text(
          'Account aanmaken',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final forgotPassword = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          _showDialog("Stuur reset email");
        },
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        child: Text(
          'Wachtwoord vergeten?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              SizedBox(height: 60),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  child: logo,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75.0),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[200],
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
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
                    SizedBox(height: 50),
                    email,
                    SizedBox(height: 10),
                    password,
                    SizedBox(height: 10),
                    loginButton,
                    googleLogIn,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        forgotPassword,
                        SizedBox(
                          width: 1,
                        ),
                        createAccount,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
