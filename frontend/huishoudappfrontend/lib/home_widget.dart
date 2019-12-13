import 'dart:convert';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/groupgrafiek.dart';
import 'package:huishoudappfrontend/groupmanagement/admin_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/invitecode_widget.dart';
import 'Objects.dart';
import 'page_container.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:http/http.dart';

class Home_widget extends StatefulWidget {
  static User currentUser;

  final ValueChanged<Widget> changeToWidget;

  Home_widget({Key key, User currentUser = null, this.changeToWidget})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new Home_widget_state();
  }
}

class Home_widget_state extends State<Home_widget> {
  String _userinfo = Home_widget.currentUser.toString();
  var currentUser = CurrentUser();
  var userhouseName;
  var appBarActions = <Widget>[];

  void initState() {
    print("user =" + currentUser.group_permission);
    appBarActions.add(Visibility(
      visible: currentUser.group_permission == "groupAdmin",
        child: IconButton(
        
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      onPressed: _toAdminWidget,
    )));
    initActual();
  }

  Future<void> initActual() async {
    String temphouse = (await House.getCurrentHouse()).houseName;

    setState(() {
      userhouseName = temphouse;
    });
  }

  Future<User> getUser() async {
    String uid = await Auth().currentUser();
    User currentUser;
    final Response res = await get(
        "http://seprojects.nl:8080/authCurrent?uid=$uid",
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

  void _changeUserInfo(String newinfo) {
    setState(() {
      _userinfo = newinfo;
    });
  }

  void _toAdminWidget() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Admin_widget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser.updateCurrentUser();
    Widget addUserToGroupButton = FlatButton(
        child: Text("Get invite code"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteCode_widget(),
              ));
        });

    if (currentUser.group_permission != "groupAdmin") {
      print(currentUser.group_permission);
      addUserToGroupButton = new Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userhouseName),
        actions: appBarActions,
        backgroundColor: Design.rood,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<User>(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("Welcome, " + snapshot.data.displayName);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<User>(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("Welcome, " + snapshot.data.displayName);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                  FlatButton(
                    child: Text("Go to Beer"),
                    onPressed: () {
                      CurrentUser currentUser = CurrentUser();

                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             BeerPage(currentUser: currentUser),
                      //       ));
                    },
                  ),
                  FlatButton(
                    child: Text("Go to group"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupWidget(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            addUserToGroupButton,
            grafiek,
          ],
        ),
      ),
    );
  }
}
