import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/schedules/clickedOnTask_widget.dart';
import '../profile.dart';
import '../Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'admintaskadder_widget.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'schoonmaakrooster_widget.dart';
import 'package:huishoudappfrontend/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClickedOnCheckHousemate extends StatefulWidget {
  static String tag = "clickedoncheckhousemate_widget";

  final Map clickedTask;

  const ClickedOnCheckHousemate({Key key, this.clickedTask}) : super(key: key);

  @override
  _ClickedOnCheckHousemateState createState() =>
      _ClickedOnCheckHousemateState();
}

class _ClickedOnCheckHousemateState extends State<ClickedOnCheckHousemate> {
  bool goedgekeurd = false;

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

  Widget doneBy() {
    return Container(
        child: Row(
      children: <Widget>[
        Text(
          "Taak gedaan door:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Spacer(),
        Text(
          widget.clickedTask["displayname"],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    ));
  }

  Widget showTaskPic() {
    return Column(
      children: <Widget>[
        Text(
          "Bijgevoegde foto:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )
        // Laat foto zien die is gijgevoegd
      ],
    );
  }

  Widget amountApprovals() {
    return Row(
      children: <Widget>[
        Text("Aantal goedkeuringen gekregen:"),
        Spacer(),
        Text(widget.clickedTask["approvals"].toString())
      ],
    );
  }

  Widget goedkeuren() {
    return Container(
      child: Row(
        children: <Widget>[
          Text("Taak voldoende?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Spacer(),
          Checkbox(
            value: goedgekeurd,
            onChanged: (bool value) {
              setState(() {
                goedgekeurd = value;
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> approveTask() async {
    var tid = widget.clickedTask["taskid"];

    final Response res = await get("http://seprojects.nl:8080/approveTask?tid=$tid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: "Je hebt deze taak goedgekeurd");
      Navigator.pop(context);
    } else {
      print(res.statusCode.toString());
    }
  }

  void buttonPressAction() {
    if (goedgekeurd) {
      approveTask();
    } else {
      Fluttertoast.showToast(msg: "Taak nog niet goedgekeurd!");
      Navigator.pop(context);
    }
  }

  Widget button() {
    return Center(
      child: RaisedButton(
        child: Text(
          "Bevestigen",
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
                SizedBox(height: 30),
                doneBy(),
                SizedBox(height: 50),
                showTaskPic(),
                goedkeuren(),
                button()
              ],
            ),
          )
        ],
      )),
    );
  }
}
