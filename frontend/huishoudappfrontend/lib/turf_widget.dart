import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'Objects.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TurfInfo {
  TurfInfo({
    this.displayname,
    this.numberofbeers,
    this.profilepicture,
  });
  final String displayname;
  int numberofbeers;
  final String profilepicture;
  Image img;

  String toString() {
    return this.displayname +
        " " +
        this.numberofbeers.toString() +
        " " +
        this.profilepicture.toString();
  }

  void setimg(Image img) {
    this.img = img;
  }
}

class Turfwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Turfwidget();
}

class _Turfwidget extends State<Turfwidget> {
  List<TurfInfo> receivedData = [];

  List<TurfInfo> sentData = [];

  @override
  void initState() {
    initActual();
    super.initState();
  }

  void initActual() async {
    BeerTally beer = await BeerTally.getData(CurrentUser().groupId);
    List pictures = beer.getPics().values.toList();
    List names = beer.getCount().keys.toList();
    List counts = beer.getCount().values.toList();
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
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    List<Image> images = [];
    for (var pic in pictures) {
      images.add(Image.memory(
          (await get("http://10.0.2.2:8080/files/users?uid=$pic&t=$timeStamp"))
              .bodyBytes));
    }
    setState(() {
      for (int i = 0; i < sentData.length; i++) {
        sentData[i].setimg(images[i]);
        print(
            "DONTYOUFUCKINGDAREREMOVETHISPRINTTHISISMYVICTORYPRINTTHISSHITFINALLYFUCKINWORKSBIATCH");
      }
    });
  }

  Widget submitButton() {
    return FlatButton(
      onPressed: () {
        finalData();
        print('pressed');
      },
      child: Text('Submit'),
    );
  }

  int getMutation(index) {
    return sentData[index].numberofbeers - receivedData[index].numberofbeers;
  }

  Future<void> finalData() async {
    CurrentUser user = CurrentUser();
    String gid = user.groupId.toString();
    String uid = user.userId;

    var updateUsers = List<HashMap<String, dynamic>>();
    for (int i = 0; i < sentData.length; i++) {
      if (receivedData[i].numberofbeers != sentData[i].numberofbeers) {
        var singleMap = HashMap<String, dynamic>();
        singleMap['targetid'] = sentData[i].profilepicture;
        singleMap['mutation'] = getMutation(i);
        updateUsers.add(singleMap);
      }
    }

    for (HashMap map in updateUsers) {
      String target = map['targetid'];
      int mutation = map['mutation'];
      final Response res = await get(
          "http://10.0.2.2:8080/updateTally?gid=$gid&authorid=$uid&targetid=$target&mutation=$mutation");
      if (res.statusCode == 200) {
        print("tally update sent");
      } else {
        print(res.statusCode);
      }
      setState(() {
        receivedData = sentData;
      });
    }
  }

  ListView createListTile(int gid) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: sentData.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: sentData[index].img,
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
                    if (sentData[index].numberofbeers == 0) {
                      print('Can' 't remove any more beers');
                    } else {
                      sentData[index].numberofbeers -= 1;
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
  }

  @override
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
        return AnimatedLiquidCustomProgressIndicator(MediaQuery.of(context).size);
      },
    );
  }
}
