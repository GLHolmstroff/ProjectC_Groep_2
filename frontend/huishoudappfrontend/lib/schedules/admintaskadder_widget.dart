import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

class AdminTaskAdder extends StatefulWidget {
  static String tag = "admintaskadder_widget";

  @override
  AdminTaskAdderState createState() => AdminTaskAdderState();
}

class AdminTaskAdderState extends State<AdminTaskAdder> {
  static String taskName, taskDescription;

  int currentGroup = CurrentUser().groupId.toInt();

  @override
  Widget build(BuildContext context) {
    final taskNameWidget = TextFormField(
      onSaved: (value) => taskName = value,
      decoration: InputDecoration(
        hintText: 'Taak naam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    Future<Null> selectedDate(BuildContext context) async {
      DateTime selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2021),
      );
    }

    final textDescriptionWidget = Text(
      "Info over de taak",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );

    final descriptionInputWidget = Container(
        height: 200,
        child: Expanded(
          child: TextFormField(
            minLines: null,
            maxLines: null,
            expands: true,
          ),
        ));

    final addTaskButtonWidget = RaisedButton(
      child: Text(
        "Taak toewijzen",
        style: TextStyle(color: Colors.amber[700]),
      ),
      onPressed: () {
        /* Functie schrijven die informatie naar de backend stuurt*/
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );

    return Center(
      child: Column(
        children: <Widget>[
          Title_Widget(text: "Taak toewijzen"),
        ],
      ),
    );
  }
}
