import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'Objects.dart';

class TurfInfo {
  TurfInfo({this.displayname, this.numberofbeers, this.profilepicture});
  final String displayname;
  final String numberofbeers;
  final String profilepicture;

  String toString() {
    return this.displayname + " " + this.numberofbeers.toString() + " " + this.profilepicture.toString(); 
  }
}

class Turfwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Turfwidget();
}

class _Turfwidget extends State<Turfwidget> {
  List<TurfInfo> receivedData = [];

  List<TurfInfo> sentData = [];




  Future<String> getImgUrl(String uid) async {
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
  }

  FutureBuilder<BeerTally> createListTile(int gid) {
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return FutureBuilder<BeerTally>(
      future: BeerTally.getData(gid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List pictures = snapshot.data.getPics().values.toList();
          List names = snapshot.data.getCount().keys.toList();
          List counts = snapshot.data.getCount().values.toList();
          receivedData.clear();
          for (int i = 0; i < pictures.length; i++) {
            receivedData.add(TurfInfo(
              displayname: names[i],
              numberofbeers: counts[i].toString(),
              profilepicture: pictures[i],
            ));
            print(receivedData[i].toString());
          }
          return ListView.builder(
            itemCount: snapshot.data.getCount().length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                    "http://10.0.2.2:8080/files/users?uid=${receivedData[index].profilepicture}&t=$timeStamp"),
                title: Text(receivedData[index].displayname),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          print('You pressed + button');
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        print('You pressed - button');
                      },
                    ),
                    Text(receivedData[index].numberofbeers)
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<House>(
      future: House.getCurrentHouse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                snapshot.data.houseName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: createListTile(snapshot.data.groupId),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
