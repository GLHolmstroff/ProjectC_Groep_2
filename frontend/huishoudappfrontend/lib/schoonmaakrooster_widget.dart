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
    
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentUser = User.fromJson(json.decode(res.body));
    } else {
      print(res.statusCode);
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
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange[800]),
    );

    final checkHousemates = Text(
      "Goedkeuren huisgenoten",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange[800]),
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: taskHeader,
           ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 225,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: Column(
                children: <Widget>[
                  
                 
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: checkHousemates,
          ),
          Container(
            height: 225,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
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
              color: Colors.grey[100],
              child: Center(
                child: RaisedButton(
                  child: Text("Huisagenda", style: TextStyle(color: Colors.white),),
                  color: Colors.orange[800],
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
