import 'package:cached_network_image/cached_network_image.dart';
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
  Map task;
  
  String imgUrl;

  void initState() {
    super.initState();
    imgUrl = "http://seprojects.nl:8080/files/tasks?tid=${widget.clickedTask["taskid"]}";
    initActual();
  }

  initActual() async {
    var res = await get(
        "http://seprojects.nl:8080/getTask?tid=${widget.clickedTask["taskid"]}");
    if (res.statusCode == 200) {
      var jsonTask = json.decode(res.body);
      setState(() {
        task = jsonTask;
      });
      String img = await getImgUrl();
      setState(() {
        imgUrl = img;
      });
    } else {
      print(res.statusCode);
    }
  }

  Future<String> getImgUrl() async {
    int tid = task["taskid"];
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://seprojects.nl:8080/files/tasks?tid=$tid&t=$timeStamp";
  }

  Widget titleWidget() {
    return Container(
      height: 100,
      child: Text(
        widget.clickedTask["taskname"],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment(-0.8, 0.8),
      decoration: BoxDecoration(
          color: Design.materialRood,
          boxShadow: [BoxShadow(color: Design.materialRood, blurRadius: 15.0)]),
    );
  }

  Widget doneBy() {
    return Container(
        child: Row(
      children: <Widget>[
        Text(
          "Taak gedaan door:",
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Text(
          widget.clickedTask["displayname"],
          style: TextStyle(fontSize: 18),
        ),
      ],
    ));
  }

  Widget showTaskPic() {
    return Column(
      children: <Widget>[
        Text(
          "Bijgevoegde foto:",
          style: TextStyle(fontSize: 16),
        ),

        Container(
          height: 200,
          child: Card(
            elevation: 3,
            child: InkWell(
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                placeholder: (context, url) => Icon(Icons.camera),
                errorWidget: (context, url, error) => Icon(Icons.camera),
              ),
            ),
          ),
        ),
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
          Text("Taak goedkeuren", style: TextStyle(fontSize: 16)),
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

    final Response res = await get(
        "http://seprojects.nl:8080/approveTask?tid=$tid",
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
        color: Design.orange2,
        child: Text(
          "Bevestigen",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                SizedBox(height: 20),
                button()
              ],
            ),
          )
        ],
      )),
    );
  }
}
