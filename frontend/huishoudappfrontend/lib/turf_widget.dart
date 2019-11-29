import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'Objects.dart';

class TurfInfo {
  TurfInfo({this.displayname, this.numberofbeers, this.profilepicture});
  final String displayname;
  int numberofbeers;
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

  
  Widget submitButton(){
    return
    FlatButton(
      onPressed: (){
        finalData();
        print('pressed');
      },
      child: Text(
        'Submit'
      ),
    );
  }

  int getMutation(index){
    return sentData[index].numberofbeers - receivedData[index].numberofbeers;
  }

  Future<void> finalData() async {
    CurrentUser user = CurrentUser();
    String gid = user.groupId.toString();
    String uid = user.userId;

    var updateUsers = List<HashMap<String, dynamic>>();
    for (int i = 0; i < sentData.length; i++){
      if (receivedData[i].numberofbeers != sentData[i].numberofbeers){
        var singleMap = HashMap<String,dynamic>();
        singleMap['targetid'] = sentData[i].profilepicture;
        singleMap['mutation'] = getMutation(i);
        updateUsers.add(singleMap);
        updateUsers.forEach( (map) async {
          String target = map['targetid'];
          int mutation = map['mutation'];
          final Response res = await get("http://10.0.2.2:8080/updateTally?gid=$gid&authorid=$uid&targetid=$target&mutation=$mutation",
          headers: {'Content-Type': 'application/json'});
      });
        

      }
    }
  }

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
              numberofbeers: counts[i],
              profilepicture: pictures[i],
            ));
            sentData.add(TurfInfo(
              displayname: names[i],
              numberofbeers: counts[i],
              profilepicture: pictures[i],
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data.getCount().length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                    "http://10.0.2.2:8080/files/users?uid=${sentData[index].profilepicture}&t=$timeStamp"),
                title: Text(sentData[index].displayname),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            sentData[index].numberofbeers += 1;
                          });
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          if (sentData[index].numberofbeers == 0){
                          print('Can''t remove any more beers');
                        }
                        else {
                          sentData[index].numberofbeers -=1;
                        }
                        });
                        
                      },
                    ),
                    Text(sentData[index].numberofbeers.toString())
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator(MediaQuery.of(context).size);
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
              backgroundColor: Design.rood,
              title: Center(
                child: Text(
                  snapshot.data.houseName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: createListTile(snapshot.data.groupId),

            ),
            floatingActionButton: submitButton(),
            
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
