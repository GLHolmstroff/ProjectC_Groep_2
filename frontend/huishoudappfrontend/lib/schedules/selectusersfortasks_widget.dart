import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/profile.dart';
import 'admintaskadder_widget.dart';
import 'schoonmaakrooster_widget.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SelectUsersForTasks extends StatefulWidget {
  @override
  _SelectUsersForTasksState createState() => _SelectUsersForTasksState();
}

class _SelectUsersForTasksState extends State<SelectUsersForTasks> {
  static CurrentUser user = CurrentUser();
  String groupId = user.groupId.toString();

  List<String> usernames = [];

  Future<void> getPicUsernameUsers() async {
    final Response res = await get(
        "http://10.0.2.2:8080/getUserInfoInGroup?gid=$groupId",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      print(json.decode(res.body));
    } else {
      print(res.statusCode.toString());
      print('Could not find group');
    }
  }

  //List<int> indexSelectedUsers = [];

  Widget usersCard(BuildContext context, int index) {
    return new Container(
      child: Card(
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Username"),
            trailing: Icon(Icons.add_circle),
            onTap: () {
              print(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getPicUsernameUsers();
    final titleWidget = Container(
      height: 100,
      child: Text(
        "Personen selecteren",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment(-0.8, 0.8),
      decoration: BoxDecoration(
          color: Design.orange2,
          boxShadow: [BoxShadow(color: Design.orange2, blurRadius: 15.0)]),
    );

    final readyButton = RaisedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new AdminTaskAdder()));
      },
      child: Text(
        "Gereed",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(color: Design.orange2)),
    );

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            titleWidget,
            SizedBox(height: 35),
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) =>
                    usersCard(context, index),
              ),
            ),
            SizedBox(height: 50),
            readyButton
          ],
        ),
      ),
    );
  }
}
