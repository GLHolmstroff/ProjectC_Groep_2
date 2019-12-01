import 'dart:async';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';
import 'Objects.dart';

class TurfInfo {
  TurfInfo({this.displayname, this.numberofbeers, this.profilepicture});
  final String displayname;
  final String numberofbeers;
  final String profilepicture;

  String toString() {
    return this.displayname +
        " " +
        this.numberofbeers.toString() +
        " " +
        this.profilepicture.toString();
  }
}

class Turfwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Turfwidget();
}

class _Turfwidget extends State<Turfwidget> {
  List<TurfInfo> receivedData = [];

  List<TurfInfo> sentData = [];

  void _printusers() async {
    Group group = await Group.getGroup();
    print(group.toString());
  }

  Future<String> getImgUrl(String uid) async {
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
  }

  ButtonBar buildButtons() {
    ButtonBar buttons = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text("Submit"),
          onPressed: () {},
        )
      ],
    );

    if (CurrentUser().group_permission == "groupAdmin") {
      buttons.children.add(FlatButton(
        child: Text("View Log"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new TurfWidgetAdmin(),
              ));
        },
      ));
    }
    return buttons;
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
                    Text(receivedData[index].numberofbeers)
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator();
      }
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
              body: Column(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.only(top: 20),
                  child: createListTile(snapshot.data.groupId),
                ),
                buildButtons()
              ]));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator();
      },
    );
  }
}
