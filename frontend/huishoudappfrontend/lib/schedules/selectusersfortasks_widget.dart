import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart' as prefix0;
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

  List savedUsers = [];

  Future<void> getPicUsernameUsers() async {
    final Response res = await get(
        "http://seprojects.nl:8080/getUserInfoInGroup?gid=$groupId",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      print(res.statusCode.toString());
      print("BAD RETURN");
    }
  }

  void addToList(var info) {
    var checker = true;
    savedUsers.forEach((user) {
      if (info["uid"] == user["uid"]) {
        checker = false;
      }
    });

    if (checker) {
      savedUsers.add(info);
      print(savedUsers);
    } else {
      print("User already selected!");
    }
  }

  Widget usersCard(BuildContext context, int index, var data) {
    return new Container(
      child: Card(
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(data[index]["displayname"]),
              trailing: Icon(Icons.add_circle),
              onTap: () {
                addToList(data[index]);
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getPicUsernameUsers();
    final titleWidget = AppBar(
      
      title: Text(
        "Personen selecteren",
        style: TextStyle(
            color: Colors.white),
      ),
     
    );

    final userCards = Container(
      height: 400,
      width: MediaQuery.of(context).size.width * 0.85,
      child: FutureBuilder(
        future: getPicUsernameUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) =>
                  usersCard(context, index, data),
            );
          }
          return Container(
            child: Text("Er is iets verkeerd gegaan..."),
          );
        },
      ),
    );

    final readyButton = RaisedButton(
      color: Design.orange2,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new AdminTaskAdder(schedule: savedUsers)));
      },
      child: Text(
        "Gereed",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(color: Design.orange2)),
    );

    return Scaffold(
      appBar: titleWidget,
      body: Center(
        child: Column(
          children: <Widget>[
            
            SizedBox(height: 35),
            userCards,
            SizedBox(height: 50),
            readyButton
          ],
        ),
      ),
    );
  }
}
