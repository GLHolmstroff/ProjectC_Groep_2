import 'dart:async';

import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';
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
  CachedNetworkImage img;

  String toString() {
    return this.displayname +
        " " +
        this.numberofbeers.toString() +
        " " +
        this.profilepicture.toString();
  }

  void setimg(CachedNetworkImage img) {
    this.img = img;
  }
}

class Turfwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Turfwidget();
}

class _Turfwidget extends State<Turfwidget> {
  List<String> pics = [];
  List<String> names = [];

  List<TurfInfo> receivedData = [];

  List<TurfInfo> sentData = [];

  List<String> turfItems = [];

  String _currentItemSelected = '';

  @override
  void initState() {
    initActual();
    super.initState();
  }

  void initActual() async {
    List<Product> products = await Product.getData(CurrentUser().groupId);
    setState(() {
      for (var product in products) {
        turfItems.add(product.name);
      }
      turfItems.sort();
      _currentItemSelected = turfItems[0];
    });

    List<Map> namePics = await Group.getNamesAndPics(CurrentUser().groupId);

    setState(() {
      for (var namePic in namePics) {
        pics.add(namePic['picture']);
        names.add(namePic['name']);
      }
    });

    BeerTally beer = await BeerTally.getData(CurrentUser().groupId, "beer");
    print(beer);
    List counts = beer.getCount().values.toList();
    for (int i = 0; i < counts.length; i++) {
      receivedData.add(TurfInfo(
        displayname: names[i],
        numberofbeers: counts[i],
        profilepicture: '',
      ));
      sentData.add(TurfInfo(
        displayname: names[i],
        numberofbeers: counts[i],
        profilepicture: '',
      ));
    }
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    List<CachedNetworkImage> images = [];
    print("Picture length: ${pics.length}");

    for (var pic in pics) {
      print("Loading image${pics.indexOf(pic)}");
      images.add(new CachedNetworkImage(
        imageUrl: "http://10.0.2.2:8080/files/users?uid=$pic&t=$timeStamp",
        placeholder: (BuildContext context, String s) {
          return new Icon(Icons.person);
        },
        errorWidget: (BuildContext context, String s, Object o) {
          return new Icon(Icons.error);
        },
      ));
    }
    print(sentData.length);
    setState(() {
      for (int i = 0; i < sentData.length; i++) {
        sentData[i].setimg(images[i]);
      }
    });
  }

  ButtonBar buildButtons() {
    ButtonBar buttons = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text("Verzenden"),
          onPressed: finalData,
        )
      ],
    );
    print(CurrentUser().group_permission);
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

  FlatButton addProducts() {
    if (CurrentUser().group_permission == 'groupAdmin') {
      FlatButton addproduct = FlatButton(
        child: Text("Producten toevoegen"),
        onPressed: () {
          print('Pressed');
        },
      );
      return addproduct;
    }
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
          "http://10.0.2.2:8080/updateTally?gid=$gid&authorid=$uid&targetid=$target&mutation=$mutation&product=beer");
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
          leading: SizedBox(
            width: MediaQuery.of(context).size.width * .15,
            child: FittedBox(
              child: sentData[index].img,
              fit: BoxFit.fill,
            ),
          ),
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

  DropdownButton dropDown() {
    var dropdownButton = DropdownButton(
      items: turfItems.map((String dropDownString) {
        return DropdownMenuItem<String>(
          value: dropDownString,
          child: Center(
            child: Text(
              dropDownString,
              style: TextStyle(fontSize: 25),
            ),
          ),
        );
      }).toList(),
      onChanged: (String newValue) async => setState(() {
        this._currentItemSelected = newValue;
      }),
      value: _currentItemSelected,
      isExpanded: true,
      icon: Icon(Icons.more_horiz),
      iconEnabledColor: Design.rood,
      iconSize: 40,
    );

    DropdownButton dropdown = dropdownButton;

    return dropdown;
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
              body: Column(children: <Widget>[
                Container(
                  child: dropDown(),
                ),
                Column(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    padding: const EdgeInsets.only(top: 10),
                    child: createListTile(snapshot.data.groupId),
                  ),
                  addProducts(),
                  buildButtons(),
                ])
              ]));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator(
            MediaQuery.of(context).size);
      },
    );
  }
}
