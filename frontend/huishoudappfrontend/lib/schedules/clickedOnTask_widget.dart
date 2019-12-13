import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/schedules/schoonmaakrooster_widget.dart';
import '../profile.dart';
import '../Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'admintaskadder_widget.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClickedOnTask extends StatefulWidget {
  static String tag = "clickedontask_widget";

  final Map clickedTask;

  const ClickedOnTask({Key key, this.clickedTask}) : super(key: key);

  @override
  _ClickedOnTaskState createState() => _ClickedOnTaskState();
}

class _ClickedOnTaskState extends State<ClickedOnTask> {
  bool taskDone = false;

  Widget titleWidget() {
    return Container(
      height: 125,
      child: Text(
        widget.clickedTask["taskname"],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment(-0.8, 0.8),
      decoration: BoxDecoration(
          color: Design.orange2,
          boxShadow: [BoxShadow(color: Design.orange2, blurRadius: 15.0)]),
    );
  }

  Widget dueDate() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "Einddatum voor deze taak:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Spacer(),
          Text(
            widget.clickedTask["datedue"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget isTaskDone() {
    if (widget.clickedTask["done"] == 0) {
      return Container(
        child: Row(
          children: <Widget>[
            Text("Taak afgerond?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Spacer(),
            Checkbox(
              value: taskDone,
              onChanged: (bool value) {
                setState(() {
                  taskDone = value;
                });
              },
            )
          ],
        ),
      );
    }
    return Container(height: 0);
  }

  Widget showApprovals() {
    if (widget.clickedTask["done"] == 1) {
      var value = widget.clickedTask["approvals"];
      return Row(
        children: <Widget>[
          Text("Goedkeuringen: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Spacer(),
          Text("$value/3",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
        ],
      );
    }
    return Container(height: 0);
  }

  Future<void> makeTaskDone() async {
    var tid = widget.clickedTask["taskid"];

    final Response res = await get("http://10.0.2.2:8080/makeTaskDone?tid=$tid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: "Taak zit nu in beoordelingsfase");
      Navigator.pop(context);
    } else {
      print(res.statusCode.toString());
    }
  }

  Future<void> endTask() async {
    var tid = widget.clickedTask["taskid"];

    final Response res = await get("http://10.0.2.2:8080/endTask?tid=$tid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: "Taak is helemaal afgerond!");
      Navigator.pop(context);
    } else {
      print(res.statusCode.toString());
    }
  }

  Widget endTaskButton() {
    if (widget.clickedTask["approvals"] >= 3) {
      return Center(
        child: RaisedButton(
          child: Text(
            "Taak volledig afronden",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            endTask();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Design.orange2)),
        ),
      );
    }
  }

  void buttonPressAction() {
    if (taskDone) {
      makeTaskDone();
    } else {
      Navigator.pop(context);
    }
  }

  Widget buildButton() {
    return Center(
      child: RaisedButton(
        child: Text(
          "Gereed",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          buttonPressAction();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36.0),
            side: BorderSide(color: Design.orange2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            titleWidget(),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  dueDate(),
                  SizedBox(height: 40),
                  isTaskDone(),
                  SizedBox(height: 50),
                  showApprovals(),
                  SizedBox(height: 70),
                  buildButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
