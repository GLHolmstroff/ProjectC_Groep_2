import 'dart:convert';

import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/groupgrafiek.dart';
import 'package:huishoudappfrontend/groupmanagement/admin_widget.dart';

import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/invitecode_widget.dart';
import 'Objects.dart';
import 'page_container.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'design.dart';

class Home_widget extends StatefulWidget {
  static User currentUser;

  final ValueChanged<Widget> changeToWidget;

  Home_widget({Key key, User currentUser = null, this.changeToWidget})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new Home_widget_state();
  }
}

class Home_widget_state extends State<Home_widget> {
  String _userinfo = Home_widget.currentUser.toString();
  var currentUser = CurrentUser();
  var userhouseName;
  var appBarActions = <Widget>[];

  void initState() {
    print("user =" + currentUser.group_permission);
    appBarActions.add(Visibility(
      visible: currentUser.group_permission == "groupAdmin",
        child: IconButton(
        
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      onPressed: _toAdminWidget,
    )));
    initActual();
  }

  Future<void> initActual() async {
    String temphouse = (await House.getCurrentHouse()).houseName;

    setState(() {
      userhouseName = temphouse;
    });
  }

  Future<User> getUser() async {
    String uid = await Auth().currentUser();
    User currentUser;
    final Response res = await get(
        "http://10.0.2.2:8080/authCurrent?uid=$uid",
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

  void _changeUserInfo(String newinfo) {
    setState(() {
      _userinfo = newinfo;
    });
  }


  void _toAdminWidget() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Admin_widget(),
        ));
  }
  
  @override
  Widget build(BuildContext context) {
    CurrentUser.updateCurrentUser();
    

    FutureBuilder grafiek = FutureBuilder<List<ConsumeDataPerMonthPerUser>>(
      future: CurrentUser().getGroupConsumeData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data[0].name);
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 3,
              child: SfCartesianChart(
                title: ChartTitle(
                  text: "Koning van de maand",
                  alignment: ChartAlignment.center,
                  textStyle: ChartTextStyle(
                    color: Design.orange2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<ConsumeDataPerMonthPerUser, String>(
                      dataSource: snapshot.data,
                      color: Design.orange2,
                      borderColor: Design.rood,
                      width: 0.4,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      xValueMapper: (ConsumeDataPerMonthPerUser data, _) =>
                          data.name,
                      yValueMapper: (ConsumeDataPerMonthPerUser data, _) =>
                          data.amount,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ]),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("${snapshot.error}");
        } else {
          return CircularProgressIndicator();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(userhouseName),
        actions: appBarActions,
        backgroundColor: Design.rood,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
            
            
            Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: grafiek,
            ),
          ],
        ),
      ),
    );
  }
}
