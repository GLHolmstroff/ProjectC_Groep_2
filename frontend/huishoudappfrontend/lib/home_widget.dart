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
  static String tag = 'home-widget';

  @override
  State<StatefulWidget> createState() {
    return new Home_widget_state();
  }
}

class Home_widget_state extends State<Home_widget> {
  CurrentUser currentUser = CurrentUser();
  String userhouseName = "Laden...";
  var appBarActions = <Widget>[];

  void initState() {
    super.initState();
    initActual();
  }

  Future<void> initActual() async {
    CurrentUser tempCurrentUser = await CurrentUser.updateCurrentUser();
    String temphouse = (await House.getCurrentHouse()).houseName;
    appBarActions.add(
      Visibility(
        visible: tempCurrentUser.group_permission == "groupAdmin",
        child: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: _toAdminWidget,
        ),
      ),
    );

    setState(() {
      userhouseName = temphouse;
      currentUser = tempCurrentUser;
    });
  }

  void _toAdminWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_widget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser.updateCurrentUser();

    FutureBuilder grafiek = FutureBuilder<List<ConsumeDataPerMonthPerUser>>(
      future: CurrentUser().getGroupConsumeData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                ],
              ),
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
        title: Text(userhouseName != null ? userhouseName : "Laden..."),
        actions: appBarActions,
        backgroundColor: Design.rood,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('welkom ' + currentUser.displayName),
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
