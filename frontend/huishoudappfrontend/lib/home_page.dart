import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/createaccount_page.dart';
import 'package:huishoudappfrontend/main.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:http/http.dart';
import 'Objects.dart';


class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}
  
class HomePageState extends State<HomePage> {
  String _userinfo;

  void _changeUserInfo(String newinfo) {
    setState(() {
     _userinfo =  newinfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_userinfo',
            ),
            (FlatButton(
              child: Text('Get Group info'),
              onPressed: () async {
                try {
                  Auth auth = Provider.of(context).auth;
                  String uid = await auth.currentUser();
                  print(uid);
                  final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
                  headers: {'Content-Type': 'application/json' });
                  print(res.statusCode);
                  if (res.statusCode == 200) {

                    // If server returns an OK response, parse the JSON.
                    User currentUser = User.fromJson(json.decode(res.body));
                    int gid = currentUser.groupId;
                    final Response res2 = await get("http://10.0.2.2:8080/getGroup?gid=$gid",
                    headers: {'Content-Type': 'application/json' });
                    print(res2.statusCode);
                    if (res2.statusCode == 200){
                      Group currentGroup = Group.fromJson(json.decode(res2.body));
                      _changeUserInfo(currentGroup.toString());
                    }
                  };
                } catch (e) {
                  print(e);
                }
                },
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.display1,
            // ),
            )
            )
            ],
          ),
        ),
      );
  }
}

