import 'package:flutter/material.dart';
import 'profile.dart';
import 'Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';

class SchoonmaakPage extends StatefulWidget {
  @override
  _SchoonmaakPageState createState() => _SchoonmaakPageState();
}

class _SchoonmaakPageState extends State<SchoonmaakPage> {
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
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Text("Profielfoto"), // Profielfoto
              Text("Username"), // Username
              Spacer(),
              Text("Taak")
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      SizedBox(height: 40),
      Text("Jouw taken",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )),
      SizedBox(height: 10),
      Container(
          height: 200,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: testList.length,
              itemBuilder: (BuildContext context, int index) =>
                  cleaningCard(context, index))),
      SizedBox(height: 30),
      Text(
        "Goedkeuren huisgenoten",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Container(
        height: 200,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) =>
              checkHousemateCard(context, index),
        ),
      ),
      SizedBox(height: 15),
      RaisedButton(
        onPressed: () {},
        child: Text(
          "Huisagenda",
          style: TextStyle(fontSize: 20),
        ),
      )
    ]));
  }
}
