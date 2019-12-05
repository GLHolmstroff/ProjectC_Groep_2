import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/schedules/selectusersfortasks_widget.dart';
import 'package:intl/intl.dart';

class AdminTaskAdder extends StatefulWidget {
  static String tag = "admintaskadder_widget";

  @override
  AdminTaskAdderState createState() => AdminTaskAdderState();
}

class AdminTaskAdderState extends State<AdminTaskAdder> {
  static String taskName, taskDescription;

  int currentGroup = CurrentUser().groupId.toInt();

  DateTime dateSelected = DateTime.now();

  String chosenPerson = "Kies";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(2019),
        lastDate: DateTime(2025));
    if (picked != null && picked != dateSelected)
      setState(() {
        dateSelected = picked;
      });
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
        onSaved: (value) => taskName = value,
        decoration: InputDecoration(
          hintText: "Taak naam",
          hintStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
        ));

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
        SizedBox(height: 20),
        Container(
          height: 50,
        )
        //TO DO Widget which shows all selected users in a listview with tiles
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
          onSaved: (value) => taskDescription = value,
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
        /* Functie schrijven die informatie naar de backend stuurt*/
      },
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          titleWidget,
          Expanded(
            child: Container(
              alignment: Alignment(-1.0, 0),
              width: 350,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 35),
                  taskNameWidget,
                  SizedBox(height: 25),
                  selectedUsersWidget,
                  SizedBox(height: 40),
                  selectDateWidget,
                  SizedBox(height: 25),
                  textDescriptionWidget,
                  SizedBox(height: 5),
                  descriptionInputWidget,
                  SizedBox(height: 20),
                  addTaskButtonWidget
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
