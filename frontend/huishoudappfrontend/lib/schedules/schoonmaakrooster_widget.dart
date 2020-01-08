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
import 'clickedOnCheckHousemate.dart';

class SchoonmaakPage extends StatefulWidget {
  static String tag = "schoonmaakrooster_widget";

  @override
  State<StatefulWidget> createState() {
    return new _SchoonmaakPageState();
  }
}

class _SchoonmaakPageState extends State<SchoonmaakPage> {
  static CurrentUser user = CurrentUser();

  // getting basic info of logged in user to work with
  String uid = user.userId.toString();
  int gid = user.groupId.toInt();
  String userPermissions = user.group_permission.toString();

  // function to make an http request to the backend that returns tasks of given user
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

  // function to make an http request to the backend that returns completed tasks of housemates
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

  Future<String> getImgUrl() async {
    String uid = await Auth().currentUser();
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
  }

  // function that returns the icon that is related to the status of a task
  Widget getIcon(int done, int approvals) {
    if (done == 0) {
      return Icon(Icons.hourglass_empty, color: Colors.orange[800]);
    }
    if (done == 1 && approvals < 2) {
      return Icon(Icons.hourglass_full, color: Colors.orange[800]);
    }
    return Icon(Icons.done_all, color: Colors.orange[800]);
  }

  // Cards worden gebruikt in de listview als items, hier heb ik mijn eigen card gemaakt met de klusnaam en verloopdatum
  Widget taskCard(BuildContext context, int index, var data) {
    return new Container(
        child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          title: Text(data[index]["taskname"]),
          subtitle: Text(data[index]["datedue"]),
          trailing: getIcon(data[index]["done"], data[index]["approvals"]),
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

  // widget that is used for making cards of user tasks
  Widget checkHousemateCard(BuildContext context, int index, var data) {
    return new Container(
      child: Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(data[index]["displayname"]),
            subtitle: Text(data[index]["taskname"]),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ClickedOnCheckHousemate(
                          clickedTask: data[index])));
            },
          ),
        ),
      ),
    );
  }

  // widget that determine if the button appears or not
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
              Navigator.pushNamed(context, AdminTaskAdder.tag);
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
    // declaration of some variables that are loaded in the build method
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

    // in this variable we load all info of tasks to check into the cards previously defined
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

    // this is the main screen layout with the widgets spread out over a column
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
