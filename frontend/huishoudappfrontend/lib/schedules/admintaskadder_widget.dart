import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/schedules/selectusersfortasks_widget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'schoonmaakrooster_widget.dart';

class AdminTaskAdder extends StatefulWidget {
  static String tag = "admintaskadder_widget";

  final List schedule;

  const AdminTaskAdder({Key key, this.schedule}) : super(key: key);

  @override
  AdminTaskAdderState createState() => AdminTaskAdderState();
}

class AdminTaskAdderState extends State<AdminTaskAdder> {
  final formKey = GlobalKey<FormState>();

  String _taskName;
  String _taskDescription;

  int currentGroup = CurrentUser().groupId.toInt();

  DateTime dateSelected = DateTime.now();
  String savedDate = "";

  // function to show a datepicker in flutter
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(2019),
        lastDate: DateTime(2025));
    if (picked != null && picked != dateSelected)
      setState(() {
        dateSelected = picked;
        savedDate = DateFormat('dd-MM-yyyy').format(picked);
      });
  }

  bool saveStates() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  // function to create a schedule with http request
  Future<void> createSchedule() async {
    if (!(widget.schedule == null)) {
      if (widget.schedule.length > 0) {
        if (saveStates()) {
          // checkers if all input is correct
          if (_taskName.length > 0 && savedDate.toString().length > 0) {
            widget.schedule.forEach((user) async {
              String uid = user["uid"];
              final response = await get(
                  "http://seprojects.nl:8080/insertSchedule?gid=$currentGroup&userid=$uid&taskname=$_taskName&description=$_taskDescription&datedue=$savedDate",
                  headers: {'Content-Type': 'application/json'});
              if (response.statusCode == 200) {
                Fluttertoast.showToast(msg: "Taak is toegevoegd!");
                print("Schedule added");
                Navigator.of(context).popUntil(ModalRoute.withName(AdminTaskAdder.tag));
                Navigator.of(context).pop();
              } else {
                print(response.statusCode.toString());
                Fluttertoast.showToast(msg: "Er is iets mis gegaan...");
              }
            });
          } else {
            Fluttertoast.showToast(msg: "Vul alle velden in!");
          }
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Selecteer minimaal 1 persoon");
      print("SCHEDULE NOT CREATED");
    }
  }

  Widget usersCard(BuildContext context, int index) {
    return new Container(
      child: Card(
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(widget.schedule[index]["displayname"]),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = Container(
      height: 100,
      child: Text(
        "Taken toewijzen",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment(-0.8, 0.8),
      decoration: BoxDecoration(
          color: Design.orange2,
          boxShadow: [BoxShadow(color: Design.orange2, blurRadius: 15.0)]),
    );

    final taskNameWidget = TextFormField(
        textAlign: TextAlign.center,
        onSaved: (value) => _taskName = value,
        decoration: InputDecoration(
          hintText: "Taak naam",
          hintStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
        ));

    Widget buildListview() {
      if (!(widget.schedule == null)) {
        print("Listview taken-toewijzen is builded");
        if (widget.schedule.length == 0) {
          return Center(
            child: Text("Nog geen personen geselecteerd!"),
          );
        }
        return new ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget.schedule.length,
          itemBuilder: (BuildContext context, int index) =>
              usersCard(context, index),
        );
      }
      return Center(
        child: Text("Nog geen personen geselecteerd!"),
      );
    }

    final selectedUsersWidget = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Selecteer personen voor deze taak: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new SelectUsersForTasks()));
              },
              child: Icon(Icons.add),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                  side: BorderSide(color: Design.orange2)),
            )
          ],
        ),
        new Container(
            height: 135,
            width: MediaQuery.of(context).size.width * 0.75,
            child: buildListview()),
      ],
    );

    final selectDateWidget = Row(
      children: <Widget>[
        Text(
          "Verloopdatum: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 35),
        Text(
          DateFormat('dd-MM-yyyy').format(dateSelected),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        RaisedButton(
          onPressed: () => _selectDate(context),
          child: Icon(Icons.date_range),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Design.orange2)),
        )
      ],
    );

    final textDescriptionWidget = Text(
      "Informatie over de taak:",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    final descriptionInputWidget = Container(
      height: 100,
      child: TextFormField(
          onSaved: (value) => _taskDescription = value,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
          )),
    );

    final addTaskButtonWidget = RaisedButton(
      child: Text(
        "Opslaan",
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.0),
          side: BorderSide(color: Design.orange2)),
      onPressed: () {
        createSchedule();
      },
    );

    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              titleWidget,
              Flexible(
                child: Container(
                  alignment: Alignment(-1.0, 0),
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 35),
                      taskNameWidget,
                      SizedBox(height: 25),
                      selectedUsersWidget,
                      SizedBox(height: 20),
                      selectDateWidget,
                      SizedBox(height: 20),
                      textDescriptionWidget,
                      SizedBox(height: 5),
                      descriptionInputWidget,
                      SizedBox(height: 15),
                      addTaskButtonWidget
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
