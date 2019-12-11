import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
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
  _SchoonmaakPageState createState() => _SchoonmaakPageState();
}

class _SchoonmaakPageState extends State<SchoonmaakPage> {
  static CurrentUser user = CurrentUser();

  String uid = user.userId.toString();
  String userPermissions = user.group_permission.toString();

  String getButtonText() {
    if (userPermissions == "groupAdmin") {
      return "Taken uitdelen";
    } else {
      return "Huisagenda";
    }
  }

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

  // Cards worden gebruikt in de listview als items, hier heb ik mijn eigen card gemaakt met de klusnaam en verloopdatum
  Widget taskCard(BuildContext context, int index, var data) {
    return new Container(
        child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Text(data[index]["taskname"]),
            Spacer(),
            Text(data[index]["datedue"])
          ],
        ),
      ),
    ));
  }

  Widget checkHousemateCard(BuildContext context, int index) {
    return new Container(
      child: Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Username"),
            subtitle: Text("Verrichte taak"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {/* Go to page of task*/},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskCardsListHeader = Container(
      height: 60,
      child: Text(
        "Jouw taken",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Design.orange2,
          boxShadow: [BoxShadow(color: Design.orange2, blurRadius: 5.0)]),
    );

    final taskCardsList = Container(
      height: 225,
      width: MediaQuery.of(context).size.width * 0.85,
      child: FutureBuilder(
        future: getUserTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) =>
                  taskCard(context, index, data),
            );
          }
          return Container(
            child: Text("Er is iets verkeerd gegaan..."),
          );
        },
      ),
    );

    final checkHousematesListHeader = Container(
      height: 60,
      child: Text(
        "goedkeuren huisgenoten",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Design.orange2,
          boxShadow: [BoxShadow(color: Design.orange2, blurRadius: 5.0)]),
    );

    return Center(
      child: Column(
        children: <Widget>[
          taskCardsListHeader,
          taskCardsList,
          checkHousematesListHeader,
          Container(
            height: 225,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) =>
                  checkHousemateCard(context, index),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.orange[700],
              child: Center(
                child: RaisedButton(
                  child: Text(getButtonText()),
                  onPressed: () {
                    if (userPermissions == "groupAdmin") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new AdminTaskAdder()));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
