import 'dart:async';

import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/turf_widget_addproduct.dart';
import 'package:path_provider/path_provider.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';
import 'Objects.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TurfInfo {
  TurfInfo({this.numberofbeers, this.uid});
  int numberofbeers;
  String uid;
}

class TurfwidgetGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TurfwidgetGrid();
}

class _TurfwidgetGrid extends State<TurfwidgetGrid> {
  List<CachedNetworkImage> pics = [];
  List<String> picIDs = [];
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
        picIDs.add(namePic['picture']);
        names.add(namePic['name']);
      }
    });

    BeerTally beer =
        await BeerTally.getData(CurrentUser().groupId, _currentItemSelected);
    print(beer);
    List<int> counts = beer.getCount();
    for (int i = 0; i < counts.length; i++) {
      receivedData.add(TurfInfo(numberofbeers: counts[i], uid: picIDs[i]));
      sentData.add(TurfInfo(numberofbeers: counts[i], uid: picIDs[i]));
    }
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    List<CachedNetworkImage> images = [];
    print("Picture length: ${picIDs.length}");

    for (var pic in picIDs) {
      print("Loading image${picIDs.indexOf(pic)}");
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
    setState(() {
      for (int i = 0; i < images.length; i++) {
        pics.add(images[i]);
      }
    });
  }

  ButtonBar buildButtons() {
    ButtonBar buttons = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text("Verzenden",
          style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onPressed: finalData,
          color: Colors.orange[700],
        )
      ],
    );
    print(CurrentUser().group_permission);
    if (CurrentUser().group_permission == "groupAdmin") {
      buttons.children.add(RaisedButton(
        child: Text("View Log",
        style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.orange[700],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new TurfWidgetAdmin(),
              ));
        },
      ));
      buttons.children.add(RaisedButton(
        child: Text("Product toevoegen",
        style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.orange[700],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new TurfWidgetAddProduct(),
              ));
        },
      ));
    }
    return buttons;
  }

  Future<void> switchProduct() async {
    BeerTally product =
        await BeerTally.getData(CurrentUser().groupId, _currentItemSelected);
    print(product);
    List<int> counts = product.getCount();
    for (int i = 0; i < counts.length; i++) {
      receivedData[i].numberofbeers = counts[i];
      sentData[i].numberofbeers = counts[i];
    }
    setState(() {
      receivedData = receivedData;
      sentData = sentData;
    });
  }

  // FlatButton addProducts() {
  //   if (CurrentUser().group_permission == 'groupAdmin') {
  //     FlatButton addproduct = FlatButton(
  //       child: Text("Producten toevoegen"),
  //       padding: EdgeInsets.symmetric(vertical: 80, horizontal: 100),
  //       onPressed: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => new TurfWidgetAddProduct(),
  //             ));
  //       },
  //     );
  //     return addproduct;
  //   }
  // }

  int getMutation(index) {
    return sentData[index].numberofbeers - receivedData[index].numberofbeers;
  }

  Future<void> finalData() async {
    CurrentUser user = CurrentUser();
    String gid = user.groupId.toString();
    String uid = user.userId;
    String product = _currentItemSelected;

    var updateUsers = List<HashMap<String, dynamic>>();
    for (int i = 0; i < sentData.length; i++) {
      if (receivedData[i].numberofbeers != sentData[i].numberofbeers) {
        var singleMap = HashMap<String, dynamic>();
        singleMap['targetid'] = sentData[i].uid;
        singleMap['mutation'] = getMutation(i);
        updateUsers.add(singleMap);
      }
    }
    print("Sending tally updates");
    for (HashMap map in updateUsers) {
      String target = map['targetid'];
      int mutation = map['mutation'];
      final Response res = await get(
          "http://10.0.2.2:8080/updateTally?gid=$gid&authorid=$uid&targetid=$target&mutation=$mutation&product=$product");
      if (res.statusCode == 200) {
        print("tally update sent");
      } else {
        print(res.statusCode);
      }
      setState(() {
        for (int i = 0; i < sentData.length; i++) {
          receivedData[i].numberofbeers = sentData[i].numberofbeers;
        }
      });
    }
  }

  GridView createGridView(int gid) {
    return GridView.builder(
      addAutomaticKeepAlives: true,
      itemCount: pics.length,
      itemBuilder: (BuildContext context, int index) {
        print(pics[index].imageUrl);
        return new Card(
          elevation: 10,
            // color: Colors.black,
            child: new GridTile(
                footer: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(1),
                          padding: EdgeInsets.all(1),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(180),
                          //     //color: Colors.orange[700],
                          //     border: Border.all(width: 1)),
                          child: IconButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              icon: Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 35,
                              ),
                              onPressed: () {
                                setState(() {
                                  sentData[index].numberofbeers += 1;
                                });
                              })),
                      Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: Design.rood,
                              border: Border.all(width: 1)),
                          child: Text(
                            sentData[index].numberofbeers.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          )),
                      Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(1),
                          padding: EdgeInsets.all(1),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(180),
                          //     color: Colors.black,
                          //     border: Border.all(width: 1)),
                          child: IconButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            icon: Icon(
                              Icons.remove,
                              color: Colors.red,
                              size: 35,
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
                          )),
                    ]),
                child: Container(
                  width: 150,
                  height: 150,
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage( 
                        image: NetworkImage(
                          pics[index].imageUrl
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(180),
                      border: Border.all(color: Design.rood, width: 3)),
                ),
                header: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 110, horizontal: 0),
                  child: Text(
                    names[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, backgroundColor: Colors.white, color: Colors.black,
                  ),
                ))));
                
      },
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
              style: TextStyle(
                fontSize: 25,
                color: Design.rood,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (String newValue) async => setState(() {
        this._currentItemSelected = newValue;
        switchProduct();
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
                title: 
                   Text(
                    "Turflijsten",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                
              ),
              body: Column(children: <Widget>[
                Container(
                  child: dropDown(),
                ),
                Column(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .60,
                    // padding: const EdgeInsets.only(top: 10),
                    child: createGridView(snapshot.data
                        .groupId), //functie neerzetten die de gridview aanmaakt
                  ),
                  //addProducts(),
                  buildButtons(), 
                ])
              ]));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child:Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
