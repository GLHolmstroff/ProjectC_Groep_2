import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/login_widget.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'Objects.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:toast/toast.dart';

class Profilepage extends StatefulWidget {
  static String tag = 'profile_page';
  _Profilepage createState() => _Profilepage();
}

class _Profilepage extends State<Profilepage> {
  final fromkey = GlobalKey<FormState>();
  FormType _formType = FormType.editprofile;
  String _name;
  bool loginWithEmail;

  Future<User> getUser() async {
    String uid = await Auth().currentUser();
    User currentUser;
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentUser = User.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return currentUser;
  }

  Future<House> getHouse() async {
    User currentUser = await getUser();
    String groupID = currentUser.groupId.toString();
    House currentGroup;
    final Response res = await get(
        "http://10.0.2.2:8080/getGroupName?gid=$groupID",
        headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentGroup = House.fromJson(json.decode(res.body));
    } else {
      print("Could not find group");
    }
    return currentGroup;
  }

  Future<bool> _loggedinWithEmail() async {
    final auth = Provider.of(context).auth;
    try {
      String loginMethode = (await auth.getUserIdToken());
      return (loginMethode == "password");
    } catch (e) {
      return false;
    }
  }

  void _sendChangePasswordEmail() async {
    final auth = Provider.of(context).auth;
    print(await auth.getUserIdToken());
    try {
      await auth.sendResetPasswordEmail(await auth.getEmailUser());
      print("ResetEmail send");
      try {
        await auth.signOut();
        print("loged out");
        Navigator.pop(context);
      } catch (a) {
        print(a);
      }
    } catch (e) {
      print(e);
    }
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
              key: fromkey,
              child: new TextFormField(
                keyboardType: TextInputType.text,
                validator: NameValidator.validate,
                onSaved: (value) => _name = value,
                decoration: InputDecoration(
                  hintText: 'Je nieuwe naam',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Opslaan"),
              onPressed: _submitnewname,
            ),
          ],
        );
      },
    );
  }

  void _submitnewname() async {
    if (fromkey.currentState.validate()) {
      fromkey.currentState.save();
      Navigator.pop(context);
      print(_name);
      String uid = await Auth().currentUser();
      final Response res = await get(
          "http://10.0.2.2:8080/userUpdateDisplayName?uid=$uid&displayname=$_name",
          headers: {'Content-Type': 'application/json'});
    }
  }

  @override
  Widget build(BuildContext context) {
    //widgets variables
    final clipper = ClipPath(
      child: Container(
        color: Colors.black.withOpacity(0.9),
      ),
      clipper: getClipper(),
    );

     FutureBuilder<User> userDisplayname = FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new GestureDetector(
            onTap: () {
              _showDialog("Verander je naam");
            },
            child: Text("Welkom, " + snapshot.data.displayName),
          );
          //return Text("Welcome, " + snapshot.data.displayName);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );

    final userImage = Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: NetworkImage('https://placeimg.com/640/480/people'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(75.0),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
    );

    final userNickname = Text(
      'placeholder bijnaam',
      style: TextStyle(
        fontSize: 17.0,
        fontStyle: FontStyle.italic,
      ),
    );

    final userHouseText = Text(
      'Jouw huis',
      style: TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
    );

    FutureBuilder<House> userHouseName = FutureBuilder<House>(
      future: getHouse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new GestureDetector(
            onTap: () {
              print('hallo');
            },
            child: Text(snapshot.data.houseName),
          );
          //return Text("Welcome, " + snapshot.data.displayName);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );

    final resetPasswordButton = Container(
      height: 30.0,
      width: 200.0,
      child: FutureBuilder<bool>(
        future: _loggedinWithEmail(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return Visibility(
                visible: snapshot.data,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.redAccent,
                  color: Colors.red,
                  elevation: 10.0,
                  child: GestureDetector(
                    onTap: () async {
                      _sendChangePasswordEmail();
                    },
                    child: Center(
                      child: Text(
                        'Reset je wachtwoord',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );

    final signOutButton = Container(
      height: 30.0,
      width: 200.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.redAccent,
        color: Colors.red,
        elevation: 10.0,
        child: GestureDetector(
          onTap: () async {
            try {
              Auth auth = Provider.of(context).auth;
              await auth.signOut();
              Navigator.pop(context);
            } catch (e) {
              print(e);
              print('logt niet uit');
            }
          },
          child: Center(
            child: Text(
              'Log uit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          clipper,
          Positioned(
            width: 400.0,
            top: MediaQuery.of(context).size.height / 8,
            child: Column(
              children: <Widget>[
                userImage,
                SizedBox(
                  height: 50.0,
                ),
                userDisplayname,
                userNickname,
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        userHouseText,
                        userHouseName,
                        resetPasswordButton,
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                signOutButton,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width * 1.9, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return true;
  }
}
