import 'package:flutter/material.dart';
import '../profile.dart';
import '../Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'admintaskadder_widget.dart';

class SchoonmaakPage extends StatefulWidget {
  static String tag = "schoonmaakrooster_widget";

  @override
  _SchoonmaakPageState createState() => _SchoonmaakPageState();
}

class _SchoonmaakPageState extends State<SchoonmaakPage> {
  String userName = CurrentUser().displayName.toString();
  String userPermissions = CurrentUser().group_permission.toString();

  String getButtonText() {
    if (userPermissions == "groupAdmin") {
      return "Taken uitdelen";
    } else {
      return "Huisagenda";
    }
  }

  List getCleaningJobs() {
    // TODO: Func moet een list returnen die alle schoonmaak taken returnt van een user
  }

  List testList = [
    "Afwas doen",
    "Badkamer schoonmaken",
    "Boodschappen doen",
    "Boodschappen doen",
    "Afwas doen",
    "Badkamer schoonmaken",
    "Boodschappen doen",
    "Boodschappen doen",
    "Afwas doen",
    "Badkamer schoonmaken",
    "Boodschappen doen",
    "Boodschappen doen",
  ];

  List testData = [
    "18-11-2019",
    "20-11-2019",
    "25-12-2019",
    "25-12-2019",
    "18-11-2019",
    "20-11-2019",
    "25-12-2019",
    "25-12-2019",
    "18-11-2019",
    "20-11-2019",
    "25-12-2019",
    "25-12-2019"
  ];

  // Cards worden gebruikt in de listview als items, hier heb ik mijn eigen card gemaakt met de klusnaam en verloopdatum
  Widget cleaningCard(BuildContext context, int index) {
    return new Container(
        child: Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Text(testList[index]),
            Spacer(),
            Text(testData[index])
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
    final taskHeader = Text(
      "Jouw taken",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );

    final checkHousemates = Text(
      "Goedkeuren huisgenoten",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 275,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange[900],
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                taskHeader,
                Container(
                  height: 225,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: testList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        cleaningCard(context, index),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 275,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange[800],
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                checkHousemates,
                Container(
                  height: 225,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) =>
                        checkHousemateCard(context, index),
                  ),
                )
              ],
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
