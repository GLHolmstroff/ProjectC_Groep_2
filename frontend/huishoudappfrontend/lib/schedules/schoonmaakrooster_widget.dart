import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/schedules/clickedOnTask_widget.dart';
import '../profile.dart';
import '../Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'admintaskadder_widget.dart';
import 'dart:convert';
import 'package:http/http.dart';

class SchoonmaakPage extends StatefulWidget {
  static String tag = "schoonmaakrooster_widget";

  @override
  State<StatefulWidget> createState() {
    return new _SchoonmaakPageState();
  }
}

class _SchoonmaakPageState extends State<SchoonmaakPage> {
  static CurrentUser user = CurrentUser();

  String uid = user.userId.toString();
  int gid = user.groupId.toInt();
  String userPermissions = user.group_permission.toString();

  Future<void> getUserTasks() async {
    final Response res = await get("http://10.0.2.2:8080/getUserTasks?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      print(res.statusCode.toString());
      print("BAD RETURN");
    }
  }

  Future<void> getHousematesChecks() async {
    final Response res = await get(
        "http://10.0.2.2:8080/getHousematesChecks?gid=$gid&uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      print(res.statusCode.toString());
      print("BAD RETURN");
    }
  }

  // Cards worden gebruikt in de listview als items, hier heb ik mijn eigen card gemaakt met de klusnaam en verloopdatum
  Widget taskCard(BuildContext context, int index, var data) {
    return new Container(
        child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          leading: Text(data[index]["taskname"]),
          trailing: Text(data[index]["datedue"]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        new ClickedOnTask(clickedTask: data[index])));
          },
        ),
      ),
    ));
  }

  Widget checkHousemateCard(BuildContext context, int index, var data) {
    return new Container(
      child: Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(data[index]["displayname"]),
            subtitle: Text(data[index]["taskname"]),
            trailing: Icon(Icons.arrow_right),
            onTap: () {/* Go to page of task*/},
          ),
        ),
      ),
    );
  }

  Widget adminButton() {
    if (userPermissions == "groupAdmin") {
      return Expanded(
        child: Center(
          child: RaisedButton(
            child: Text(
              "Taken toewijzen",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AdminTaskAdder()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
                side: BorderSide(color: Design.orange2)),
          ),
        ),
      );
    }
    return Container(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskCardsListHeader = Text(
      "Jouw taken",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.orange[800]),
    );

    final taskCardsList = Container(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.85,
      child: FutureBuilder(
        future: getUserTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data.length > 0) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) =>
                    taskCard(context, index, data),
              );
            }
          }
          return Container(
            child: Center(
              child: Text(
                "Je hebt geen taken op het moment",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );

    final checkHousematesListHeader = Text(
      "goedkeuren huisgenoten",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.orange[800]),
    );

    final checkHousematesCardsList = Container(
      height: 210,
      width: MediaQuery.of(context).size.width * 0.85,
      child: FutureBuilder(
        future: getHousematesChecks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data.length > 0) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) =>
                    checkHousemateCard(context, index, data),
              );
            }
          }
          return Container(
            child: Center(
              child: Text(
                "Er zijn geen taken om te controleren",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          taskCardsListHeader,
          taskCardsList,
          SizedBox(height: 30),
          checkHousematesListHeader,
          checkHousematesCardsList,
          adminButton()
        ],
      ),
    );
  }
}
