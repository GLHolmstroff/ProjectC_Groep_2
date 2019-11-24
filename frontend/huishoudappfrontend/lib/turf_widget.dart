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
  final profilepicture;
}

List<TurfInfo> receivedData = [
  TurfInfo(
      displayname: CurrentUser().displayName,
      numberofbeers: '0',
      profilepicture: Icons.person),
];

class Turfwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Turfwidget();
}

class _Turfwidget extends State<Turfwidget> {
  void _printusers() async {
    Group group = await Group.getGroup();
    print(group.toString());
  }
  
  Future<String> getImgUrl(String uid) async {
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
  }

  FutureBuilder<BeerTally> createListTile(int gid) {
    String timeStamp = DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return FutureBuilder<BeerTally>(
      future: BeerTally.getData(gid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.getCount().length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network("http://10.0.2.2:8080/files/users?uid=${snapshot.data.getPics().values.toList()[index]}&t=$timeStamp"),
                title: Text(snapshot.data.getCount().keys.toList()[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          _printusers();
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
                    Text(snapshot.data.getCount().values.toList()[index].toString())
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
